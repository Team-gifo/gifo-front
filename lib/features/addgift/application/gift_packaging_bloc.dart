import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:retrofit/dio.dart' show HttpResponse;

import '../../../core/di/service_locator.dart';
import '../model/bgm_preset.dart';
import '../model/gacha_content.dart';
import '../model/gallery_item.dart';
import '../model/gift_content.dart';
import '../model/gift_request.dart';
import '../model/quiz_content.dart';
import '../model/unboxing_content.dart';
import '../repository/addgift_api.dart';
import 'bgm_preset/bgm_preset_bloc.dart';

part 'gift_packaging_event.dart';
part 'gift_packaging_state.dart';

class GiftPackagingBloc extends Bloc<GiftPackagingEvent, GiftPackagingState> {
  final BgmPresetBloc _bgmPresetBloc;

  GiftPackagingBloc(this._bgmPresetBloc) : super(GiftPackagingState.initial()) {
    on<SetMode>(_onSetMode);
    on<SetReceiverName>(_onSetReceiverName);
    on<SetGalleryItems>(_onSetGalleryItems);
    on<SetSubTitle>(_onSetSubTitle);
    on<SetBgm>(_onSetBgm);
    on<SetContentType>(_onSetContentType);
    on<SetGachaContent>(_onSetGachaContent);
    on<SetQuizContent>(_onSetQuizContent);
    on<SetUnboxingContent>(_onSetUnboxingContent);
    on<SubmitPackage>(_onSubmitPackage);
    on<ResetPackaging>(_onResetPackaging);
  }

  void _onSetMode(SetMode event, Emitter<GiftPackagingState> emit) {
    emit(state.copyWith(mode: event.mode));
  }

  void _onSetReceiverName(
    SetReceiverName event,
    Emitter<GiftPackagingState> emit,
  ) {
    emit(state.copyWith(receiverName: event.name));
  }

  void _onSetGalleryItems(
    SetGalleryItems event,
    Emitter<GiftPackagingState> emit,
  ) {
    emit(state.copyWith(gallery: event.items));
  }

  void _onSetSubTitle(SetSubTitle event, Emitter<GiftPackagingState> emit) {
    emit(state.copyWith(subTitle: event.subTitle));
  }

  void _onSetBgm(SetBgm event, Emitter<GiftPackagingState> emit) {
    emit(state.copyWith(bgm: event.bgm));
  }

  void _onSetContentType(
    SetContentType event,
    Emitter<GiftPackagingState> emit,
  ) {
    emit(state.copyWith(selectedContentType: event.type));
  }

  void _onSetGachaContent(
    SetGachaContent event,
    Emitter<GiftPackagingState> emit,
  ) {
    emit(state.copyWith(gachaContent: event.gacha));
  }

  void _onSetQuizContent(
    SetQuizContent event,
    Emitter<GiftPackagingState> emit,
  ) {
    emit(state.copyWith(quizContent: event.quiz));
  }

  void _onSetUnboxingContent(
    SetUnboxingContent event,
    Emitter<GiftPackagingState> emit,
  ) {
    emit(state.copyWith(unboxingContent: event.unboxing));
  }

  // --- 포장 완료: 이미지 업로드 후 이벤트 데이터를 조립하여 서버 전송 ---
  Future<void> _onSubmitPackage(
    SubmitPackage event,
    Emitter<GiftPackagingState> emit,
  ) async {
    // 전송 시작: 로딩 상태로 전환
    emit(state.copyWith(submitStatus: SubmitStatus.loading));

    try {
      _logSubmitStart(event);

      // 1. 갤러리 이미지 업로드 (MEMORY 타입)
      debugPrint('[GiftPackagingBloc] 1/3 갤러리 이미지 업로드 시작');
      final List<GalleryItem> uploadedGallery = await Future.wait(
        event.gallery.asMap().entries.map((
          MapEntry<int, GalleryItem> entry,
        ) async {
          final int index = entry.key;
          final GalleryItem item = entry.value;
          debugPrint(
            '[GiftPackagingBloc]   - gallery[$index] 업로드 대상: ${_shortText(item.imageUrl)}',
          );
          final String url = await _uploadLocalImage(item.imageUrl, 'MEMORY');
          debugPrint(
            '[GiftPackagingBloc]   - gallery[$index] 업로드 완료: ${_shortText(url)}',
          );
          return item.copyWith(imageUrl: url);
        }),
      );
      debugPrint('[GiftPackagingBloc] 1/3 갤러리 이미지 업로드 완료');

      // 2. 콘텐츠 이미지 업로드
      debugPrint('[GiftPackagingBloc] 2/3 콘텐츠 이미지 업로드 시작');
      final GiftContent uploadedContent = await _uploadContentImages(
        event.content,
      );
      debugPrint('[GiftPackagingBloc] 2/3 콘텐츠 이미지 업로드 완료');

      // preset ID → URL 변환
      String bgmUrl = event.bgm;
      final List<BgmPreset> presets = _bgmPresetBloc.state.presets;
      final Iterable<BgmPreset> matched =
          presets.where((BgmPreset p) => p.id == event.bgm);
      if (matched.isNotEmpty && matched.first.url.isNotEmpty) {
        bgmUrl = matched.first.url;
      }
      debugPrint('[GiftPackagingBloc] BGM 변환: "${event.bgm}" → "$bgmUrl"');

      final GiftRequest request = GiftRequest(
        user: event.receiverName,
        subTitle: event.subTitle,
        bgm: bgmUrl,
        gallery: uploadedGallery,
        content: uploadedContent,
      );

      // JSON 변환 후 로그 출력
      final Map<String, dynamic> jsonMap = request.toJson();

      // null content 필드 제거 (Freezed는 nullable 필드를 null로 직렬화하므로)
      final Map<String, dynamic>? contentMap = _toJsonMap(jsonMap['content']);
      if (contentMap != null) {
        contentMap.removeWhere((String key, dynamic value) => value == null);
        jsonMap['content'] = contentMap;
      }

      final String prettyJson = const JsonEncoder.withIndent(
        '  ',
      ).convert(jsonMap);
      debugPrint('========================================');
      debugPrint('[GiftPackagingBloc] 선물 포장 완료 - 서버 전송 데이터:');
      debugPrint(prettyJson);
      debugPrint('========================================');

      debugPrint('[GiftPackagingBloc] 3/3 이벤트 생성 API 호출 시작 (POST /api/events)');
      final AddGiftApi api = getIt<AddGiftApi>();
      final HttpResponse<dynamic> response = await api.createGift(jsonMap);
      debugPrint(
        '[GiftPackagingBloc] 서버 전송 성공! (상태 코드: ${response.response.statusCode})',
      );

      // 서버 응답에서 공유 URL 및 코드 파싱
      final Map<String, dynamic>? responseData = _toJsonMap(response.data);
      final Map<String, dynamic>? data = _toJsonMap(responseData?['data']);
      final String shareUrl = data?['eventUrl'] as String? ?? '';
      final String shareCode =
          data?['eventCode'] as String? ??
          (shareUrl.isNotEmpty ? shareUrl.split('/').last : '');

      if (shareUrl.isEmpty) {
        debugPrint(
          '[GiftPackagingBloc] 경고: 서버 응답에 eventUrl이 없습니다. raw=${response.data}',
        );
      }

      // 전송 완료: 성공 상태로 전환 (뷰에서 이 상태를 감지해 화면 전환)
      emit(
        state.copyWith(
          submitStatus: SubmitStatus.success,
          shareUrl: shareUrl,
          shareCode: shareCode,
        ),
      );
    } on DioException catch (e, stackTrace) {
      _logDioException(e, stackTrace, stage: 'submitPackage');
      emit(state.copyWith(submitStatus: SubmitStatus.failure));
    } catch (e, stackTrace) {
      debugPrint('========================================');
      debugPrint('[GiftPackagingBloc] submitPackage 단계에서 알 수 없는 예외 발생');
      debugPrint('에러 내용: $e');
      debugPrint('스택 트레이스:\n$stackTrace');
      debugPrint('========================================');

      // 전송 실패: 실패 상태로 전환
      emit(state.copyWith(submitStatus: SubmitStatus.failure));
    }
  }

  // 로컬 파일 경로이면 서버에 업로드 후 URL 반환, 이미 URL이면 그대로 반환
  Future<String> _uploadLocalImage(String path, String type) async {
    if (path.isEmpty || path.startsWith('http')) {
      debugPrint(
        '[GiftPackagingBloc] 이미지 업로드 스킵(type=$type): ${_shortText(path)}',
      );
      return path;
    }

    final XFile xFile = XFile(path);
    final Uint8List bytes = await xFile.readAsBytes();
    final String rawName = path.split('/').last.split('?').first;

    final String mimeSubtype = _detectImageSubtype(bytes, rawName);
    final String fileName = rawName.contains('.')
        ? rawName
        : '$rawName.$mimeSubtype';
    final MultipartFile multipartFile = MultipartFile.fromBytes(
      bytes,
      filename: fileName,
      contentType: DioMediaType('image', mimeSubtype),
    );

    debugPrint(
      '[GiftPackagingBloc] 이미지 업로드 요청(type=$type, file=$fileName, bytes=${bytes.length})',
    );
    final AddGiftApi api = getIt<AddGiftApi>();
    final HttpResponse<dynamic> response = await api.uploadImage(
      type,
      multipartFile,
    );
    final Map<String, dynamic>? responseData = _toJsonMap(response.data);
    final Map<String, dynamic>? data = _toJsonMap(responseData?['data']);
    final String uploadedUrl = data?['imageUrl'] as String? ?? path;
    debugPrint(
      '[GiftPackagingBloc] 이미지 업로드 응답(type=$type, status=${response.response.statusCode}) -> ${_shortText(uploadedUrl)}',
    );
    return uploadedUrl;
  }

  // 콘텐츠 타입별 이미지 업로드 후 URL이 교체된 GiftContent 반환
  Future<GiftContent> _uploadContentImages(GiftContent content) async {
    if (content.gacha != null) {
      final GachaContent gacha = content.gacha!;
      debugPrint(
        '[GiftPackagingBloc] 콘텐츠 타입: gacha (아이템 ${gacha.list.length}개)',
      );
      final List<GachaItem> uploadedItems = await Future.wait(
        gacha.list.asMap().entries.map((MapEntry<int, GachaItem> entry) async {
          final int index = entry.key;
          final GachaItem item = entry.value;
          debugPrint(
            '[GiftPackagingBloc]   - gacha[$index] 업로드 대상: ${_shortText(item.imageUrl)}',
          );
          final String url = await _uploadLocalImage(item.imageUrl, 'GIFT');
          debugPrint(
            '[GiftPackagingBloc]   - gacha[$index] 업로드 완료: ${_shortText(url)}',
          );
          return item.copyWith(imageUrl: url);
        }),
      );
      return content.copyWith(gacha: gacha.copyWith(list: uploadedItems));
    }

    if (content.quiz != null) {
      final QuizContent quiz = content.quiz!;
      debugPrint('[GiftPackagingBloc] 콘텐츠 타입: quiz (문제 ${quiz.list.length}개)');
      final List<QuizItemModel> uploadedItems = await Future.wait(
        quiz.list.asMap().entries.map((
          MapEntry<int, QuizItemModel> entry,
        ) async {
          final int index = entry.key;
          final QuizItemModel item = entry.value;
          if (item.imageUrl == null || item.imageUrl!.isEmpty) return item;
          debugPrint(
            '[GiftPackagingBloc]   - quiz[$index] 업로드 대상: ${_shortText(item.imageUrl!)}',
          );
          final String url = await _uploadLocalImage(item.imageUrl!, 'QUIZ');
          debugPrint(
            '[GiftPackagingBloc]   - quiz[$index] 업로드 완료: ${_shortText(url)}',
          );
          return item.copyWith(imageUrl: url);
        }),
      );
      debugPrint(
        '[GiftPackagingBloc]   - successReward 업로드 대상: ${_shortText(quiz.successReward.imageUrl)}',
      );
      final String successUrl = await _uploadLocalImage(
        quiz.successReward.imageUrl,
        'QUIZ',
      );
      debugPrint(
        '[GiftPackagingBloc]   - failReward 업로드 대상: ${_shortText(quiz.failReward.imageUrl)}',
      );
      final String failUrl = await _uploadLocalImage(
        quiz.failReward.imageUrl,
        'QUIZ',
      );
      return content.copyWith(
        quiz: quiz.copyWith(
          list: uploadedItems,
          successReward: quiz.successReward.copyWith(imageUrl: successUrl),
          failReward: quiz.failReward.copyWith(imageUrl: failUrl),
        ),
      );
    }

    if (content.unboxing != null) {
      final UnboxingContent unboxing = content.unboxing!;
      debugPrint('[GiftPackagingBloc] 콘텐츠 타입: unboxing');
      final String beforeUrl = await _uploadLocalImage(
        unboxing.beforeOpen.imageUrl,
        'GIFT',
      );
      final String afterUrl = await _uploadLocalImage(
        unboxing.afterOpen.imageUrl,
        'GIFT',
      );
      return content.copyWith(
        unboxing: unboxing.copyWith(
          beforeOpen: unboxing.beforeOpen.copyWith(imageUrl: beforeUrl),
          afterOpen: unboxing.afterOpen.copyWith(imageUrl: afterUrl),
        ),
      );
    }

    return content;
  }

  void _logSubmitStart(SubmitPackage event) {
    debugPrint('========================================');
    debugPrint('[GiftPackagingBloc] submitPackage 시작');
    debugPrint('receiverName: "${event.receiverName}"');
    debugPrint('subTitle: "${event.subTitle}"');
    debugPrint('bgm: "${event.bgm}"');
    debugPrint('galleryCount: ${event.gallery.length}');
    debugPrint('contentType: ${_contentTypeLabel(event.content)}');
    debugPrint('========================================');
  }

  void _logDioException(
    DioException e,
    StackTrace stackTrace, {
    required String stage,
  }) {
    debugPrint('========================================');
    debugPrint('[GiftPackagingBloc] $stage 단계에서 DioException 발생');
    debugPrint('type: ${e.type}');
    debugPrint('message: ${e.message}');
    debugPrint('request: ${e.requestOptions.method} ${e.requestOptions.uri}');
    debugPrint('query: ${e.requestOptions.queryParameters}');
    debugPrint('requestBody: ${e.requestOptions.data}');
    if (e.response != null) {
      debugPrint('statusCode: ${e.response?.statusCode}');
      debugPrint('responseBody: ${e.response?.data}');
      debugPrint('responseHeaders: ${e.response?.headers.map}');
    }
    debugPrint('stackTrace:\n$stackTrace');
    debugPrint('========================================');
  }

  Map<String, dynamic>? _toJsonMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map(
        (dynamic key, dynamic mapValue) =>
            MapEntry<String, dynamic>(key.toString(), mapValue),
      );
    }
    return null;
  }

  String _contentTypeLabel(GiftContent content) {
    if (content.gacha != null) return 'gacha';
    if (content.quiz != null) return 'quiz';
    if (content.unboxing != null) return 'unboxing';
    return 'unknown';
  }

  String _detectImageSubtype(Uint8List bytes, String fileName) {
    if (bytes.length >= 4 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return 'png';
    }
    if (bytes.length >= 3 &&
        bytes[0] == 0xFF &&
        bytes[1] == 0xD8 &&
        bytes[2] == 0xFF) {
      return 'jpeg';
    }
    final String ext = fileName.split('.').last.toLowerCase();
    if (ext == 'png' || ext == 'jpg' || ext == 'jpeg') return ext;
    return 'jpeg';
  }

  String _shortText(String value) {
    if (value.length <= 120) return value;
    return '${value.substring(0, 117)}...';
  }

  void _onResetPackaging(
    ResetPackaging event,
    Emitter<GiftPackagingState> emit,
  ) {
    emit(GiftPackagingState.initial());
  }
}
