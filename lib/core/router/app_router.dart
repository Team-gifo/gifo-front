import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/addgift/application/gift_packaging_bloc.dart';
import '../../features/addgift/presentation/views/direct_open_setting_view.dart';
import '../../features/addgift/presentation/views/gacha_setting_view.dart';
import '../../features/addgift/presentation/views/gift_delivery_method_view.dart';
import '../../features/addgift/presentation/views/memory_decision_view.dart';
import '../../features/addgift/presentation/views/memory_gallery_setting_view.dart';
import '../../features/addgift/presentation/views/package_complete_view.dart';
import '../../features/addgift/presentation/views/quiz_setting_view.dart';
import '../../features/addgift/presentation/views/receiver_name_view.dart';
import '../../features/content/application/gacha/gacha_bloc.dart';
import '../../features/content/application/quiz/quiz_bloc.dart';
import '../../features/content/application/unboxing/unboxing_bloc.dart';
import '../../features/content/presentation/gacha/gacha_view.dart';
import '../../features/content/presentation/quiz/quiz_view.dart';
import '../../features/content/presentation/result/result_view.dart';
import '../../features/content/presentation/unboxing/unboxing_view.dart';
import '../../features/home/presentation/views/home_view.dart';
import '../../features/lobby/model/lobby_data.dart';
import '../../features/lobby/presentation/views/lobby_view.dart';
import '../../features/lobby/presentation/views/memory_gallery_view.dart';

bool isPackageComplete = false;
final GiftPackagingBloc giftPackagingBloc = GiftPackagingBloc();

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  redirect: (BuildContext context, GoRouterState state) {
    if (isPackageComplete) {
      if (state.matchedLocation.startsWith('/addgift') &&
          state.matchedLocation != '/addgift/package-complete') {
        return '/';
      }
    }
    return null;
  },
  routes: <RouteBase>[
    // 메인화면
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) => const HomeView(),
    ),
    // 콘텐츠 이용 전 로비 화면
    GoRoute(
      path: '/lobby',
      builder: (BuildContext context, GoRouterState state) {
        // 전달된 초대코드를 사용하여 데이터를 생성 (기본값: helloworld)
        final String code = state.extra as String? ?? 'helloworld';
        final lobbyData =
            LobbyData.getDummyByCode(code) ??
            LobbyData.getDummyByCode('helloworld')!;
        return LobbyView(data: lobbyData, code: code);
      },
    ),
    // 수신자용 추억 갤러리 화면 (입장 후 화면)
    GoRoute(
      path: '/memory-gallery',
      builder: (BuildContext context, GoRouterState state) {
        final String code = state.extra as String? ?? 'helloworld';
        return MemoryGalleryView(code: code);
      },
    ),
    // 콘텐츠 진행 - 캡슐 뽑기 화면
    GoRoute(
      path: '/content/gacha',
      builder: (BuildContext context, GoRouterState state) {
        final code = state.extra as String? ?? 'helloworld';
        return BlocProvider<GachaBloc>(
          create: (context) => GachaBloc(),
          child: GachaView(code: code),
        );
      },
    ),
    // 콘텐츠 진행 - 퀴즈 맞추기 화면
    GoRoute(
      path: '/content/quiz',
      builder: (BuildContext context, GoRouterState state) {
        final code = state.extra as String? ?? 'quiz123';
        return BlocProvider<QuizBloc>(
          create: (context) => QuizBloc(),
          child: QuizView(code: code),
        );
      },
    ),
    // 콘텐츠 진행 - 바로 오픈 화면
    GoRoute(
      path: '/content/unboxing',
      builder: (BuildContext context, GoRouterState state) {
        final String code = state.extra as String? ?? 'open123';
        return BlocProvider<UnboxingBloc>(
          create: (context) => UnboxingBloc(),
          child: UnboxingView(code: code),
        );
      },
    ),
    // 콘텐츠 진행 - 공용 결과창 화면
    GoRoute(
      path: '/content/result',
      builder: (BuildContext context, GoRouterState state) {
        final Map<String, dynamic>? extra =
            state.extra as Map<String, dynamic>?;
        final String itemName = extra?['itemName'] as String? ?? '결과 없음';
        final String imageUrl =
            extra?['imageUrl'] as String? ?? 'assets/images/title_logo.png';
        return ResultView(itemName: itemName, imageUrl: imageUrl);
      },
    ),
    // 선물 포장하기 전체 플로우 (ShellRoute로 묶어 GiftPackagingBloc 상태 유지)
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return BlocProvider<GiftPackagingBloc>.value(
          value: giftPackagingBloc,
          child: child,
        );
      },
      routes: [
        // 선물 포장 - 받는 분 성함 입력 화면
        GoRoute(
          path: '/addgift',
          builder: (BuildContext context, GoRouterState state) =>
              const ReceiverNameView(),
        ),
        // 선물 포장 - 추억 공유 여부 선택 화면
        GoRoute(
          path: '/addgift/memory-decision',
          builder: (BuildContext context, GoRouterState state) =>
              const MemoryDecisionView(),
        ),
        // 선물 포장 - 추억 갤러리 셋팅 화면 (추억 저장하는 공간)
        GoRoute(
          path: '/addgift/memory-gallery',
          builder: (BuildContext context, GoRouterState state) =>
              const MemoryGallerySettingView(),
        ),
        // 선물 포장 - 선물 전달 방식(오픈 콘텐츠) 선택 화면
        GoRoute(
          path: '/addgift/delivery-method',
          builder: (BuildContext context, GoRouterState state) =>
              const GiftDeliveryMethodView(),
        ),
        // 선물 포장 - 가차(캡슐 뽑기) 세팅 화면
        GoRoute(
          path: '/addgift/gacha-setting',
          builder: (BuildContext context, GoRouterState state) =>
              const GachaSettingView(),
        ),
        // 선물 포장 - 퀴즈 세팅 화면
        GoRoute(
          path: '/addgift/quiz-setting',
          builder: (BuildContext context, GoRouterState state) =>
              const QuizSettingView(),
        ),
        // 선물 포장 - 바로 오픈 세팅 화면
        GoRoute(
          path: '/addgift/direct-open-setting',
          builder: (BuildContext context, GoRouterState state) =>
              const DirectOpenSettingView(),
        ),
        // 선물 포장 - 등록 완료 화면
        GoRoute(
          path: '/addgift/package-complete',
          builder: (BuildContext context, GoRouterState state) =>
              const PackageCompleteView(),
        ),
      ],
    ),
  ],
);
