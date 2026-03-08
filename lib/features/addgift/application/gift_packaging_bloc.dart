import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  // --- 포장 완료 시 전체 데이터를 GiftRequest로 조립하여 로그 출력 후 서버 전송 ---
  Future<void> _onSubmitPackage(
    SubmitPackage event,
    Emitter<GiftPackagingState> emit,
  ) async {
    final GiftContent content = _buildContent();
    final GiftRequest request = GiftRequest(
      user: state.receiverName,
      subTitle: state.subTitle,
      bgm: state.bgm,
      gallery: state.gallery,
      content: content,
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
      final api = getIt<AddGiftApi>();
      final response = await api.createGift(jsonMap);
      debugPrint(
        '[GiftPackagingBloc] 서버 전송 성공! (상태 코드: ${response.response.statusCode})',
      );
    } catch (e) {
      if (e is num) {
        // e is num은 발생할리 없으므로 dynamic으로 DioException 판별 우회(타입을 명시적으로 안 써도 되도록)
      }
      // 통신 중 터졌거나 에러 응답을 받았을 경우
      final errorStr = e.toString();
      String statusCode = '알 수 없음';
      if (errorStr.contains('statusCode')) {
        // 에러 객체 안에 statusCode 정보가 있을 수 있음
        debugPrint('[GiftPackagingBloc] 서버 전송 에러 발생: $errorStr');
      } else {
        debugPrint(
          '[GiftPackagingBloc] 서버 전송 실패. 네트워크를 확인하세요 (응답 코드: $statusCode) - $e',
        );
      }
    }
  }

  // 선택된 콘텐츠 타입에 따라 GiftContent 조립
  GiftContent _buildContent() {
    switch (state.selectedContentType) {
      case ContentType.gacha:
        return GiftContent(gacha: state.gachaContent);
      case ContentType.quiz:
        return GiftContent(quiz: state.quizContent);
      case ContentType.unboxing:
        return GiftContent(unboxing: state.unboxingContent);
      default:
        return const GiftContent();
    }
  }

  void _onResetPackaging(
    ResetPackaging event,
    Emitter<GiftPackagingState> emit,
  ) {
    emit(GiftPackagingState.initial());
  }
}
