import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gifo/core/blocs/download/download_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/constants/app_breakpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/grid_background_painter.dart';
import '../../../lobby/application/lobby_bloc.dart';
import '../../../lobby/model/lobby_data.dart';
import '../../application/gacha/gacha_bloc.dart';
import 'gacha_result_modal.dart';
import 'gacha_widgets.dart';

// code 파라미터 제거: 라우터에서 BLoC 생성 시 InitGacha 이벤트가 먼저 발행됨
class GachaView extends StatefulWidget {
  const GachaView({super.key});

  @override
  State<GachaView> createState() => _GachaViewState();
}

class _GachaViewState extends State<GachaView> {
  final GlobalKey<GachaMachineSectionState> _machineKey =
      GlobalKey<GachaMachineSectionState>();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= AppBreakpoints.desktop;
    final bool isMobileOrSmall = screenWidth < AppBreakpoints.desktop;

    return MultiBlocListener(
      listeners: <BlocListener>[
        // 백그라운드 로딩(SilentRefreshLobbyData)으로 인해 새로운 로비 데이터가 도착하면 가챠 모델을 갱신
        BlocListener<LobbyBloc, LobbyState>(
          listenWhen: (LobbyState prev, LobbyState curr) =>
              prev.lobbyData != curr.lobbyData && curr.lobbyData != null,
          listener: (BuildContext context, LobbyState state) {
            final GachaState gachaState = context.read<GachaBloc>().state;
            if (gachaState.isResultRefreshing) {
              context.read<GachaBloc>().add(
                InitGacha(state.lobbyData!, inviteCode: gachaState.inviteCode),
              );
            }
          },
        ),
      ],
      child: BlocConsumer<GachaBloc, GachaState>(
        // 뽑기 결과가 나오면 머신 애니메이션 시작 후 완료 시 모달 표시
        listenWhen: (GachaState prev, GachaState curr) =>
            curr.lastDrawnItem != null &&
            prev.lastDrawnItem != curr.lastDrawnItem,
        listener: (BuildContext context, GachaState state) {
          if (state.lastDrawnItem != null) {
            _machineKey.currentState?.startResultAnimation(
              state.lastDrawnItem!,
            );
          }
        },
        builder: (BuildContext context, GachaState state) {
          Widget mainContent;
          if (state.gachaContent == null) {
            mainContent = Title(
              title: 'Happy Birthday, ${state.userName} | Gifo',
              color: Colors.black,
              child: Skeletonizer(
                enabled: true,
                child: Scaffold(
                  backgroundColor: AppColors.darkBg,
                  body: isDesktop
                      ? _buildDesktopLayout(state)
                      : _buildMobileLayout(state, isMobileOrSmall),
                ),
              ),
            );
          } else {
            mainContent = Title(
              title: 'Happy Birthday, ${state.userName} | Gifo',
              color: Colors.black,
              child: Skeletonizer(
                enabled: state.isDrawing,
                child: Scaffold(
                  backgroundColor: AppColors.darkBg,
                  body: SafeArea(
                    child: Stack(
                      children: <Widget>[
                        // 배경 그리드 패턴
                        Positioned.fill(
                          child: CustomPaint(painter: GridBackgroundPainter()),
                        ),
                        // 상단 AppBar 영역
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: _buildAppBar(state, isMobileOrSmall),
                        ),
                        // 메인 콘텐츠 영역
                        Positioned.fill(
                          top: isMobileOrSmall ? 64 : 72,
                          child: isDesktop
                              ? _buildDesktopLayout(state)
                              : _buildMobileLayout(state, isMobileOrSmall),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          return Stack(
            children: <Widget>[
              mainContent,
              // 터치 방지 및 진행 표시: 백그라운드 데이터 갱신 중
              if (state.isResultRefreshing)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withValues(
                      alpha: 0.5,
                    ), // 배경을 살짝 어둡게 (터치 방지)
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.neonPurple,
                      ),
                    ),
                  ),
                ),
              // 다운로드(기프티콘 일괄 생성) 로딩 오버레이
              BlocBuilder<DownloadBloc, DownloadState>(
                builder: (BuildContext context, DownloadState dlState) {
                  if (dlState.status == DownloadStatus.loading) {
                    return Positioned.fill(
                      child: Material(
                        type: MaterialType.transparency,
                        child: Container(
                          color: Colors.black.withValues(alpha: 0.7),
                          child: const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                CircularProgressIndicator(
                                  color: AppColors.neonPurple,
                                ),
                                SizedBox(height: 24),
                                Text(
                                  '기프티콘 생성 중...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'WantedSans',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '압축 파일이 준비될 때까지 잠시만 기다려주세요.',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontFamily: 'WantedSans',
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          );
        },
      ),
    );
  }

  // AppBar: 로고 + 타이틀
  Widget _buildAppBar(GachaState state, bool isMobileOrSmall) {
    final bool isMobile =
        MediaQuery.of(context).size.width < AppBreakpoints.tablet;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkBg.withValues(alpha: 0.8),
        border: Border(
          bottom: BorderSide(
            color: AppColors.neonPurple.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.neonPurple.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobileOrSmall ? 16.0 : 32.0,
          vertical: 12.0,
        ),
        child: Row(
          children: <Widget>[
            if (!isMobile) ...<Widget>[
              // 로고 (홈으로 이동 가능) - 모바일에서 숨김
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () async {
                    final Uri homeUri = Uri.base.resolve('/');
                    if (await canLaunchUrl(homeUri)) {
                      await launchUrl(homeUri, webOnlyWindowName: '_blank');
                    } else {
                      if (context.mounted) context.go('/');
                    }
                  },
                  child: Image.asset(
                    'assets/images/title_logo.png',
                    height: isMobileOrSmall ? 40 : 48,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ] else ...<Widget>[const SizedBox(width: 8)],
            // 타이틀 텍스트
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: isMobileOrSmall ? 15 : 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'WantedSans',
                ),
                children: <InlineSpan>[
                  TextSpan(
                    text: state.userName,
                    style: const TextStyle(color: AppColors.neonPurple),
                  ),
                  const TextSpan(text: '님의 '),
                  const TextSpan(
                    text: '신나는 오락',
                    style: TextStyle(color: AppColors.neonPurple),
                  ),
                  const TextSpan(text: ' 뽑기'),
                ],
              ),
            ),
            const Spacer(),
            // 데스크탑/태블릿(모바일 이외)에서 남은 횟수 표시
            if (!isMobileOrSmall) ...<Widget>[
              GachaRemainingBadge(count: state.remainingCount),
            ],
            // 모바일에서 히스토리 및 경품 목록 버튼
            if (isMobileOrSmall) ...<Widget>[
              IconButton(
                icon: const Icon(Icons.card_giftcard, color: Colors.white70),
                onPressed: () => _showMobilePrizeModal(state),
                tooltip: '경품 목록',
              ),
              Badge(
                label: Text(
                  state.history.length > 99
                      ? '99+'
                      : state.history.length.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                isLabelVisible: state.history.isNotEmpty,
                backgroundColor: AppColors.neonPurple,
                child: IconButton(
                  icon: const Icon(Icons.history, color: Colors.white70),
                  onPressed: () => _showMobileHistoryModal(state),
                  tooltip: '뽑기 히스토리',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // 데스크톱: 3단 레이아웃 (히스토리 | 머신 | 경품 목록)
  Widget _buildDesktopLayout(GachaState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: GachaHistoryPanel(
              history: state.history,
              userName: state.userName,
              inviteCode: state.inviteCode,
            ),
          ),
          const SizedBox(width: 28),
          Expanded(
            flex: 2,
            child: GachaMachineSection(
              key: _machineKey,
              remainingCount: state.remainingCount,
              items: state.gachaContent?.list ?? <GachaItem>[],
              onDraw: state.remainingCount > 0
                  ? () => context.read<GachaBloc>().add(const DrawGacha())
                  : null,
              onAnimationComplete: (GachaItem item) {
                showGachaResultModal(context, item);
              },
            ),
          ),
          const SizedBox(width: 28),
          Expanded(
            flex: 1,
            child: GachaPrizeListPanel(
              items: state.gachaContent?.list ?? <GachaItem>[],
            ),
          ),
        ],
      ),
    );
  }

  // 모바일/태블릿: 단일 컬럼 (머신 전체 활용, 중앙 정렬)
  Widget _buildMobileLayout(GachaState state, bool isMobileOrSmall) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 32),
        child: Center(
          child: GachaMachineSection(
            key: _machineKey,
            remainingCount: state.remainingCount,
            items: state.gachaContent?.list ?? <GachaItem>[],
            onDraw: state.remainingCount > 0
                ? () => context.read<GachaBloc>().add(const DrawGacha())
                : null,
            onAnimationComplete: (GachaItem item) {
              showGachaResultModal(context, item);
            },
          ),
        ),
      ),
    );
  }

  // 모바일 전용 히스토리 바텀시트
  void _showMobileHistoryModal(GachaState state) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          decoration: const BoxDecoration(
            color: Color(0xFF130E1F),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: <Widget>[
              _buildBottomSheetHandle(),
              const SizedBox(height: 16),
              Expanded(
                child: GachaHistoryPanel(
                  history: state.history,
                  userName: state.userName,
                  inviteCode: state.inviteCode,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 모바일 전용 경품 목록 바텀시트
  void _showMobilePrizeModal(GachaState state) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          decoration: const BoxDecoration(
            color: Color(0xFF130E1F),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: <Widget>[
              _buildBottomSheetHandle(),
              const SizedBox(height: 16),
              Expanded(
                child: GachaPrizeListPanel(items: state.gachaContent!.list),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetHandle() {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
