import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/addgift/presentation/views/memory_decision_view.dart';
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
  ],
);
