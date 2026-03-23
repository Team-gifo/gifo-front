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
import '../../features/lobby/application/lobby_bloc.dart';
import '../../features/lobby/model/lobby_data.dart';
import '../../features/lobby/presentation/views/lobby_view.dart';
import '../../features/lobby/presentation/views/memory_gallery_view.dart';

bool isPackageComplete = false;
final GiftPackagingBloc giftPackagingBloc = GiftPackagingBloc();

// 잘못된 경로 접근 시 toast를 한 번만 보여주기 위한 전역 플래그
// URL 파라미터(?invalidCode=true)를 사용하면 주소창이 더러워지고 새로고침 시 계속 뜨는 문제를 방지하기 위함
bool _shouldShowInvalidCodeToast = false;

// 잘못된 경로 접근 시 home 이동 + toast를 처리하는 위젯
class _ErrorRedirectPage extends StatefulWidget {
  const _ErrorRedirectPage();

  @override
  State<_ErrorRedirectPage> createState() => _ErrorRedirectPageState();
}

class _ErrorRedirectPageState extends State<_ErrorRedirectPage> {
  @override
  void initState() {
    super.initState();
    // 위젯이 완전히 렌더링된 이후에 이동 (build 중 context 사용 방지)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      
      final routerState = GoRouterState.of(context);
      final currentPath = routerState.uri.path;
      
      // sitemap.xml, robots.txt 등 정적 파일 요청이나 개발망 경로가 강제로 플러터로 넘어온 경우
      // '잘못된 초대코드' 토스트가 뜨는 것을 방지
      final isStaticFile = currentPath.endsWith('.xml') || 
                           currentPath.endsWith('.txt') || 
                           currentPath.endsWith('.png') ||
                           currentPath.endsWith('.json');
                           
      if (!isStaticFile) {
        _shouldShowInvalidCodeToast = true;
      }
      
      GoRouter.of(context).go('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    // 리다이렉트 전 빈 화면 (깜빡임 최소화)
    return const Scaffold(backgroundColor: Colors.black);
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  // 정의되지 않은 경로로 접근하면 _ErrorRedirectPage로 처리
  errorBuilder: (BuildContext context, GoRouterState state) =>
      const _ErrorRedirectPage(),
  redirect: (BuildContext context, GoRouterState state) {
    // 선물 포장 완료 후 addgift 루트 접근 차단
    if (isPackageComplete) {
      if (state.matchedLocation.startsWith('/addgift') &&
          state.matchedLocation != '/addgift/package-complete') {
        return '/';
      }
    }
    // /gift/code/:code 진입 시 코드 유효성 사전 검증
    // 유효하지 않으면 errorBuilder 대신 redirect로 처리
    if (state.matchedLocation.startsWith('/gift/code/')) {
      final String code = state.matchedLocation
          .replaceFirst('/gift/code/', '')
          .trim();
      if (code.isEmpty || LobbyData.getDummyByCode(code) == null) {
        _shouldShowInvalidCodeToast = true;
        return '/';
      }
    }
    return null;
  },
  routes: <RouteBase>[
    // 메인화면 - 전역 플래그를 확인하여 toast 출력 여부 결정 (URL 파라미터 미사용)
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        // 플래그를 읽고 즉시 false로 초기화하여 1회성 동작 보장
        final bool showToast = _shouldShowInvalidCodeToast;
        if (showToast) _shouldShowInvalidCodeToast = false;

        return HomeView(showInvalidCodeToast: showToast);
      },
    ),
    // 콘텐츠 이용 전 로비 화면 (초대코드 직접 입력 후 내부 이동용, 레거시)
    GoRoute(
      path: '/lobby',
      pageBuilder: (BuildContext context, GoRouterState state) {
        final String code = state.extra as String? ?? 'helloworld';
        final lobbyData =
            LobbyData.getDummyByCode(code) ??
            LobbyData.getDummyByCode('helloworld')!;
        return NoTransitionPage(
          child: LobbyView(data: lobbyData, code: code),
        );
      },
    ),
    // 초대 코드 기반 로비 화면 - URL 경로에 코드가 포함되는 공유 가능한 형태
    // redirect에서 유효성 검증을 이미 통과한 코드만 진입
    GoRoute(
      path: '/gift/code/:code',
      pageBuilder: (BuildContext context, GoRouterState state) {
        final String code = state.pathParameters['code'] ?? '';
        // redirect에서 유효성 검증 완료: null-fallback 불필요
        final LobbyData lobbyData = LobbyData.getDummyByCode(code)!;
        return NoTransitionPage(
          child: BlocProvider(
            create: (_) => LobbyBloc(),
            child: LobbyView(data: lobbyData, code: code),
          ),
        );
      },
    ),
    // 수신자용 추억 갤러리 화면 (입장 후 화면)
    GoRoute(
      path: '/memory-gallery',
      pageBuilder: (BuildContext context, GoRouterState state) {
        final String code = state.extra as String? ?? 'helloworld';
        return NoTransitionPage(
          child: MemoryGalleryView(code: code),
        );
      },
    ),
    // 콘텐츠 진행 - 캡슐 뽑기 화면
    GoRoute(
      path: '/content/gacha',
      pageBuilder: (BuildContext context, GoRouterState state) {
        final code = state.extra as String? ?? 'helloworld';
        return NoTransitionPage(
          child: BlocProvider<GachaBloc>(
            create: (context) => GachaBloc(),
            child: GachaView(code: code),
          ),
        );
      },
    ),
    // 콘텐츠 진행 - 퀴즈 맞추기 화면
    GoRoute(
      path: '/content/quiz',
      pageBuilder: (BuildContext context, GoRouterState state) {
        final code = state.extra as String? ?? 'quiz123';
        return NoTransitionPage(
          child: BlocProvider<QuizBloc>(
            create: (context) => QuizBloc(),
            child: QuizView(code: code),
          ),
        );
      },
    ),
    // 콘텐츠 진행 - 바로 오픈 화면
    GoRoute(
      path: '/content/unboxing',
      pageBuilder: (BuildContext context, GoRouterState state) {
        final String code = state.extra as String? ?? 'open123';
        return NoTransitionPage(
          child: BlocProvider<UnboxingBloc>(
            create: (context) => UnboxingBloc(),
            child: UnboxingView(code: code),
          ),
        );
      },
    ),
    // 콘텐츠 진행 - 공용 결과창 화면
    GoRoute(
      path: '/content/result',
      pageBuilder: (BuildContext context, GoRouterState state) {
        final Map<String, dynamic>? extra =
            state.extra as Map<String, dynamic>?;
        final String itemName = extra?['itemName'] as String? ?? '결과 없음';
        final String imageUrl =
            extra?['imageUrl'] as String? ?? 'assets/images/title_logo.png';
        final String userName = extra?['userName'] as String? ?? '';
        return NoTransitionPage(
          child: ResultView(
            itemName: itemName,
            imageUrl: imageUrl,
            userName: userName,
          ),
        );
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
