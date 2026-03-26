import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:retrofit/dio.dart';

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

  // --- 포장 완료: 이벤트에 담긴 데이터로 GiftRequest 조립 후 서버 전송 ---
  Future<void> _onSubmitPackage(
    SubmitPackage event,
    Emitter<GiftPackagingState> emit,
  ) async {
    // 전송 시작: 로딩 상태로 전환
    emit(state.copyWith(submitStatus: SubmitStatus.loading));

    final GiftRequest request = GiftRequest(
      user: event.receiverName,
      subTitle: event.subTitle,
      bgm: event.bgm,
      gallery: event.gallery,
      content: event.content,
    );

    // JSON 변환 후 로그 출력
    final Map<String, dynamic> jsonMap = request.toJson();
    final String prettyJson = const JsonEncoder.withIndent(
      '  ',
    ).convert(jsonMap);
    debugPrint('========================================');
    debugPrint('[GiftPackagingBloc] 선물 포장 완료 - 서버 전송 데이터:');
    debugPrint(prettyJson);
    debugPrint('========================================');

    try {
      final AddGiftApi api = getIt<AddGiftApi>();
      final HttpResponse<dynamic> response = await api.createGift(jsonMap);
      debugPrint(
        '[GiftPackagingBloc] 서버 전송 성공! (상태 코드: ${response.response.statusCode})',
      );

      // 서버 응답에서 공유 코드 파싱 (필드명 미확정으로 방어 파싱)
      final Map<String, dynamic>? responseData =
          response.data as Map<String, dynamic>?;
      final String shareCode =
          responseData?['invite_code'] as String? ??
          responseData?['code'] as String? ??
          responseData?['share_code'] as String? ??
          '';
      final String shareUrl = shareCode.isNotEmpty
          ? Uri.base.resolve('/gift/code/$shareCode').toString()
          : responseData?['share_url'] as String? ?? '';

      // 전송 완료: 성공 상태로 전환 (뷰에서 이 상태를 감지해 화면 전환)
      emit(state.copyWith(
        submitStatus: SubmitStatus.success,
        shareCode: shareCode,
        shareUrl: shareUrl,
      ));
    } catch (e, stackTrace) {
      debugPrint('========================================');
      debugPrint('[GiftPackagingBloc] 서버 전송 중 예외 발생!');
      debugPrint('에러 내용: $e');
      debugPrint('스택 트레이스: \n$stackTrace');

      final String errorStr = e.toString();
      if (errorStr.contains('statusCode')) {
        debugPrint('[GiftPackagingBloc] 상세 에러 (StatusCode 포함): $errorStr');
      }
      debugPrint('========================================');

      // 전송 실패: 실패 상태로 전환
      emit(state.copyWith(submitStatus: SubmitStatus.failure));
    }
  }

  void _onResetPackaging(
    ResetPackaging event,
    Emitter<GiftPackagingState> emit,
  ) {
    emit(GiftPackagingState.initial());
  }
}
