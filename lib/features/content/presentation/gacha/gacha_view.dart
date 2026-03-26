import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_breakpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/grid_background_painter.dart';
import '../../../lobby/model/lobby_data.dart';
import '../../application/gacha/gacha_bloc.dart';
import 'gacha_result_modal.dart';
import 'gacha_widgets.dart';

class GachaView extends StatefulWidget {
  final String code;

  const GachaView({super.key, required this.code});

  @override
  State<GachaView> createState() => _GachaViewState();
}

class _GachaViewState extends State<GachaView> {
  final GlobalKey<GachaMachineSectionState> _machineKey =
      GlobalKey<GachaMachineSectionState>();

  @override
  void initState() {
    super.initState();
    context.read<GachaBloc>().add(InitGacha(widget.code));
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= AppBreakpoints.desktop;
    final bool isMobileOrSmall = screenWidth < AppBreakpoints.desktop;

    return BlocConsumer<GachaBloc, GachaState>(
      // 뽑기 결과가 나오면 머신 애니메이션 시작 후 완료 시 모달 표시
      listenWhen: (GachaState prev, GachaState curr) =>
          curr.lastDrawnItem != null && prev.lastDrawnItem != curr.lastDrawnItem,
      listener: (BuildContext context, GachaState state) {
        if (state.lastDrawnItem != null) {
          // BLoC에서 결과가 넘어오면 머신 위젯의 '결과 낙하' 애니메이션 트리거
          _machineKey.currentState?.startResultAnimation(state.lastDrawnItem!);
        }
      },
      builder: (BuildContext context, GachaState state) {
        if (state.gachaContent == null) {
          return Title(
            title: 'Happy Birthday, ${state.userName} | Gifo',
            color: Colors.black,
            child: const Scaffold(
              backgroundColor: AppColors.darkBg,
              body: Center(
                child: CircularProgressIndicator(color: AppColors.neonPurple),
              ),
            ),
          );
        }

        return Title(
          title: 'Happy Birthday, ${state.userName} | Gifo',
          color: Colors.black,
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
        );
      },
    );
  }

  // AppBar: memory_gallery_view 방식 (로고 + 타이틀), 타이틀 텍스트는 기존 103~112번 코드 유지
  Widget _buildAppBar(GachaState state, bool isMobileOrSmall) {
    final bool isMobile = MediaQuery.of(context).size.width < AppBreakpoints.tablet;

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
            ] else ...<Widget>[
              const SizedBox(width: 8),
            ],
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
            // 모바일에서 히스토리 및 경품 목록 버튼
            if (isMobileOrSmall) ...<Widget>[
              IconButton(
                icon: const Icon(Icons.card_giftcard, color: Colors.white70),
                onPressed: () => _showMobilePrizeModal(state),
                tooltip: '경품 목록',
              ),
              IconButton(
                icon: const Icon(Icons.history, color: Colors.white70),
                onPressed: () => _showMobileHistoryModal(state),
                tooltip: '뽑기 히스토리',
              ),
            ],
          ],
        ),
      ),
    );
  }

  // 데스크톱: 3단 레이아웃 (히스토리 | 머신 | 경품 목록) - 가변 너비 적용
  Widget _buildDesktopLayout(GachaState state) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // 좌측: 히스토리 패널 (가변 너비)
          Expanded(
            flex: 1,
            child: GachaHistoryPanel(
              history: state.history,
              userName: state.userName,
              inviteCode: widget.code,
            ),
          ),
          const SizedBox(width: 28),
          // 중앙: 가챠 머신 섹션 (가세 비율 유지하며 중앙 집중)
          Expanded(
            flex: 2,
            child: GachaMachineSection(
              key: _machineKey,
              remainingCount: state.remainingCount,
              items: state.gachaContent!.list,
              onDraw: state.remainingCount > 0
                  ? () => context.read<GachaBloc>().add(const DrawGacha())
                  : null,
              onAnimationComplete: (GachaItem item) {
                showGachaResultModal(context, item);
              },
            ),
          ),
          const SizedBox(width: 28),
          // 우측: 경품 목록 패널 (가변 너비)
          Expanded(
            flex: 1,
            child: GachaPrizeListPanel(items: state.gachaContent!.list),
          ),
        ],
      ),
    );
  }

  // 모바일: 단일 컬럼 (머신 전체 활용), 히스토리/경품은 AppBar 아이콘으로 접근
  Widget _buildMobileLayout(GachaState state, bool isMobileOrSmall) {
    return Column(
      children: <Widget>[
        // 중앙 머신 섹션 (가변 높이)
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
            child: GachaMachineSection(
              key: _machineKey,
              remainingCount: state.remainingCount,
              items: state.gachaContent!.list,
              onDraw: state.remainingCount > 0
                  ? () => context.read<GachaBloc>().add(const DrawGacha())
                  : null,
              onAnimationComplete: (GachaItem item) {
                showGachaResultModal(context, item);
              },
            ),
          ),
        ),
      ],
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
              const SizedBox(height: 8),
              const Text(
                '뽑기 히스토리',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'WantedSans',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GachaHistoryPanel(
                  history: state.history,
                  userName: state.userName,
                  inviteCode: widget.code,
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
              const SizedBox(height: 8),
              const Text(
                '경품 목록',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'WantedSans',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(child: GachaPrizeListPanel(items: state.gachaContent!.list)),
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
