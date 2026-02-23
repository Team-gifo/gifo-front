import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/addgift/presentation/views/gacha_setting_view.dart';
import '../../features/addgift/presentation/views/gift_delivery_method_view.dart';
import '../../features/addgift/presentation/views/direct_open_setting_view.dart';
import '../../features/addgift/presentation/views/memory_decision_view.dart';
import '../../features/addgift/presentation/views/memory_gallery_setting_view.dart';
import '../../features/addgift/presentation/views/quiz_setting_view.dart';
import '../../features/addgift/presentation/views/receiver_name_view.dart';
import '../../features/home/presentation/views/home_view.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    // 메인화면
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) => const HomeView(),
    ),
    // 선물 포장 - 받는 분 성함 입력 화면
    GoRoute(
      path: '/addgift/receiver-name',
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
  ],
);
