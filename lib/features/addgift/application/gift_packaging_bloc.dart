import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:retrofit/dio.dart' show HttpResponse;

import '../../../core/di/service_locator.dart';
import '../model/gacha_content.dart';
import '../model/gallery_item.dart';
import '../model/gift_content.dart';
import '../model/gift_request.dart';
import '../model/quiz_content.dart';
import '../model/unboxing_content.dart';
import '../repository/addgift_api.dart';

part 'gift_packaging_event.dart';
part 'gift_packaging_state.dart';

class GiftPackagingBloc extends Bloc<GiftPackagingEvent, GiftPackagingState> {
  GiftPackagingBloc() : super(GiftPackagingState.initial()) {
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
      // 1. 갤러리 이미지 업로드 (MEMORY 타입)
      final List<GalleryItem> uploadedGallery = await Future.wait(
        event.gallery.map((GalleryItem item) async {
          final String url = await _uploadLocalImage(item.imageUrl, 'MEMORY');
          return item.copyWith(imageUrl: url);
        }),
      );

      // 2. 콘텐츠 이미지 업로드
      final GiftContent uploadedContent = await _uploadContentImages(event.content);

      final GiftRequest request = GiftRequest(
        user: event.receiverName,
        subTitle: event.subTitle,
        bgm: event.bgm,
        gallery: uploadedGallery,
        content: uploadedContent,
      );

      // JSON 변환 후 로그 출력
      final Map<String, dynamic> jsonMap = request.toJson();

      // null content 필드 제거 (Freezed는 nullable 필드를 null로 직렬화하므로)
      final Map<String, dynamic>? contentMap =
          jsonMap['content'] as Map<String, dynamic>?;
      if (contentMap != null) {
        contentMap.removeWhere((String key, dynamic value) => value == null);
      }

      final String prettyJson = const JsonEncoder.withIndent(
        '  ',
      ).convert(jsonMap);
      debugPrint('========================================');
      debugPrint('[GiftPackagingBloc] 선물 포장 완료 - 서버 전송 데이터:');
      debugPrint(prettyJson);
      debugPrint('========================================');

      final AddGiftApi api = getIt<AddGiftApi>();
      final HttpResponse<dynamic> response = await api.createGift(jsonMap);
      debugPrint(
        '[GiftPackagingBloc] 서버 전송 성공! (상태 코드: ${response.response.statusCode})',
      );

      // 서버 응답에서 공유 URL 파싱
      final Map<String, dynamic>? responseData =
          response.data as Map<String, dynamic>?;
      final Map<String, dynamic>? data =
          responseData?['data'] as Map<String, dynamic>?;
      final String shareUrl = data?['eventUrl'] as String? ?? '';

      // 전송 완료: 성공 상태로 전환 (뷰에서 이 상태를 감지해 화면 전환)
      emit(state.copyWith(
        submitStatus: SubmitStatus.success,
        shareUrl: shareUrl,
      ));
    } catch (e, stackTrace) {
      debugPrint('========================================');
      debugPrint('[GiftPackagingBloc] 서버 전송 중 예외 발생!');
      debugPrint('에러 내용: $e');
      debugPrint('스택 트레이스: \n$stackTrace');
      debugPrint('========================================');

      // 전송 실패: 실패 상태로 전환
      emit(state.copyWith(submitStatus: SubmitStatus.failure));
    }
  }

  // 로컬 파일 경로이면 서버에 업로드 후 URL 반환, 이미 URL이면 그대로 반환
  Future<String> _uploadLocalImage(String path, String type) async {
    if (path.isEmpty || path.startsWith('http')) return path;

    final XFile xFile = XFile(path);
    final Uint8List bytes = await xFile.readAsBytes();
    final String rawName = path.split('/').last.split('?').first;
    final String fileName = rawName.isEmpty ? 'image.jpg' : rawName;

    final MultipartFile multipartFile = MultipartFile.fromBytes(
      bytes,
      filename: fileName,
    );

    final AddGiftApi api = getIt<AddGiftApi>();
    final HttpResponse<dynamic> response = await api.uploadImage(type, multipartFile);
    final Map<String, dynamic> responseData =
        response.data as Map<String, dynamic>;
    final Map<String, dynamic> data =
        responseData['data'] as Map<String, dynamic>;
    return data['imageUrl'] as String? ?? path;
  }

  // 콘텐츠 타입별 이미지 업로드 후 URL이 교체된 GiftContent 반환
  Future<GiftContent> _uploadContentImages(GiftContent content) async {
    if (content.gacha != null) {
      final GachaContent gacha = content.gacha!;
      final List<GachaItem> uploadedItems = await Future.wait(
        gacha.list.map((GachaItem item) async {
          final String url = await _uploadLocalImage(item.imageUrl, 'GIFT');
          return item.copyWith(imageUrl: url);
        }),
      );
      return content.copyWith(
        gacha: gacha.copyWith(list: uploadedItems),
      );
    }

    if (content.quiz != null) {
      final QuizContent quiz = content.quiz!;
      final List<QuizItemModel> uploadedItems = await Future.wait(
        quiz.list.map((QuizItemModel item) async {
          if (item.imageUrl == null || item.imageUrl!.isEmpty) return item;
          final String url = await _uploadLocalImage(item.imageUrl!, 'QUIZ');
          return item.copyWith(imageUrl: url);
        }),
      );
      final String successUrl =
          await _uploadLocalImage(quiz.successReward.imageUrl, 'QUIZ');
      final String failUrl =
          await _uploadLocalImage(quiz.failReward.imageUrl, 'QUIZ');
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
      final String beforeUrl =
          await _uploadLocalImage(unboxing.beforeOpen.imageUrl, 'GIFT');
      final String afterUrl =
          await _uploadLocalImage(unboxing.afterOpen.imageUrl, 'GIFT');
      return content.copyWith(
        unboxing: unboxing.copyWith(
          beforeOpen: unboxing.beforeOpen.copyWith(imageUrl: beforeUrl),
          afterOpen: unboxing.afterOpen.copyWith(imageUrl: afterUrl),
        ),
      );
    }

    return content;
  }

  void _onResetPackaging(
    ResetPackaging event,
    Emitter<GiftPackagingState> emit,
  ) {
    emit(GiftPackagingState.initial());
  }
}
