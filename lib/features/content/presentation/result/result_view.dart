import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_breakpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/share_helper.dart';
import '../../../../core/widgets/grid_background_painter.dart';
import '../../../../core/widgets/shared_confetti_widget.dart';
import '../../application/result/result_bloc.dart';

class ResultView extends StatelessWidget {
  final String itemName;
  final String imageUrl;
  final String userName;
  final String inviteCode;

  const ResultView({
    super.key,
    required this.itemName,
    required this.imageUrl,
    this.userName = '',
    this.inviteCode = '',
  });

  @override
  Widget build(BuildContext context) {
    // 결과 화면에 필요한 ResultBloc 주입
    // DownloadBloc은 라우트 상위에서 주입되어 있어야 한다
    return BlocProvider<ResultBloc>(
      create: (_) => ResultBloc(),
      child: _ResultBody(
        itemName: itemName,
        imageUrl: imageUrl,
        userName: userName,
        inviteCode: inviteCode,
      ),
    );
  }
}

class _ResultBody extends StatelessWidget {
  final String itemName;
  final String imageUrl;
  final String userName;
  final String inviteCode;

  const _ResultBody({
    required this.itemName,
    required this.imageUrl,
    required this.userName,
    required this.inviteCode,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= AppBreakpoints.desktop;
    final bool isTablet = screenWidth >= AppBreakpoints.tablet;

    return Title(
      title: 'Happy Birthday, $userName | Gifo',
      color: Colors.black,
      child: Scaffold(
        backgroundColor: AppColors.darkBg,
        appBar: _buildAppBar(),
        body: Stack(
          children: <Widget>[
            // 그리드 배경
            Positioned.fill(
              child: CustomPaint(painter: GridBackgroundPainter()),
            ),
            // 상단 색종이 효과
            const Align(
              alignment: Alignment.topCenter,
              child: SharedConfettiWidget(autoPlay: true),
            ),
            // 메인 콘텐츠
            SafeArea(
              child: SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isDesktop ? 800 : double.infinity,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 48 : 24,
                        vertical: isDesktop ? 60 : 40,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _buildCongratsBadge(),
                          SizedBox(height: isDesktop ? 48 : 32),
                          _buildItemImage(isDesktop, isTablet),
                          SizedBox(height: isDesktop ? 40 : 28),
                          _buildItemNameCard(isDesktop),
                          SizedBox(height: isDesktop ? 48 : 36),
                          _buildActionRow(context),
                          const SizedBox(height: 24),
                          _buildHomeButton(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Image.asset('assets/images/title_logo.png', height: 40),
      ),
    );
  }

  // 상단 축하 뱃지 위젯
  Widget _buildCongratsBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF130E1F),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.neonPurple.withValues(alpha: 0.4),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.neonPurple.withValues(alpha: 0.2),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(
            Icons.celebration_rounded,
            color: AppColors.neonPurple,
            size: 18,
          ),
          const SizedBox(width: 10),
          Text(
            '생일 축하드립니다!',
            style: TextStyle(
              fontFamily: 'PFStardust',
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.9),
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemImage(bool isDesktop, bool isTablet) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: isDesktop ? 480 : (isTablet ? 380 : 300),
        maxWidth: isDesktop ? 560 : (isTablet ? 440 : double.infinity),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.neonPurple.withValues(alpha: 0.4),
          width: 1.5,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.neonPurple.withValues(alpha: 0.15),
            blurRadius: 32,
            spreadRadius: 4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(19),
        child: imageUrl.startsWith('http')
            ? Image.network(imageUrl, fit: BoxFit.contain)
            : Image.asset(imageUrl, fit: BoxFit.contain),
      ),
    );
  }

  // 당첨 아이템 이름 카드
  Widget _buildItemNameCard(bool isDesktop) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF130E1F),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.neonPurple.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: <Widget>[
          Text(
            '선물 결과',
            style: TextStyle(
              fontFamily: 'WantedSans',
              fontSize: 13,
              color: AppColors.neonPurple.withValues(alpha: 0.8),
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            itemName,
            style: TextStyle(
              fontFamily: 'PFStardust',
              fontSize: isDesktop ? 30 : 22,
              color: Colors.white,
              letterSpacing: 1,
              shadows: <Shadow>[
                Shadow(
                  color: AppColors.neonPurple.withValues(alpha: 0.5),
                  blurRadius: 12,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // 공유 / 다운로드 버튼 Row
  Widget _buildActionRow(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _ShareButton(
            userName: userName,
            inviteCode: inviteCode,
            itemName: itemName,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _DownloadButton(
            itemName: itemName,
            imageUrl: imageUrl,
            userName: userName,
            inviteCode: inviteCode,
          ),
        ),
      ],
    );
  }

  Widget _buildHomeButton(BuildContext context) {
    return TextButton(
      onPressed: () => context.go('/'),
      style: TextButton.styleFrom(
        foregroundColor: Colors.white38,
      ),
      child: const Text(
        '홈으로 돌아가기',
        style: TextStyle(
          fontFamily: 'WantedSans',
          fontSize: 14,
          decoration: TextDecoration.underline,
          decorationColor: Colors.white38,
        ),
      ),
    );
  }
}

// ==========================================
// 친구에게 결과 공유하기 버튼
// ShareHelper를 통해 클립보드 복사 수행
// ==========================================
class _ShareButton extends StatelessWidget {
  final String userName;
  final String inviteCode;
  final String itemName;

  const _ShareButton({
    required this.userName,
    required this.inviteCode,
    required this.itemName,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Material(
        borderRadius: BorderRadius.circular(14),
        color: Colors.transparent,
        child: InkWell(
          onTap: () => ShareHelper.shareResultToClipboard(
            context: context,
            userName: userName,
            inviteCode: inviteCode,
            itemNames: <String>[itemName],
          ),
          borderRadius: BorderRadius.circular(14),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(
                colors: <Color>[Color(0xFFBC13FE), Color(0xFF8B5CF6)],
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.neonPurple.withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.share_rounded, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      '친구에게 결과 공유',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'WantedSans',
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 이미지 다운로드 버튼
// ResultBloc -> DownloadBloc 위임 처리
// ==========================================
class _DownloadButton extends StatelessWidget {
  final String itemName;
  final String imageUrl;
  final String userName;
  final String inviteCode;

  const _DownloadButton({
    required this.itemName,
    required this.imageUrl,
    required this.userName,
    required this.inviteCode,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResultBloc, ResultState>(
      builder: (BuildContext context, ResultState state) {
        final bool isLoading =
            state.downloadStatus == ResultDownloadStatus.loading;

        return SizedBox(
          height: 56,
          child: Material(
            borderRadius: BorderRadius.circular(14),
            color: Colors.transparent,
            child: InkWell(
              onTap: isLoading
                  ? null
                  : () => context.read<ResultBloc>().add(
                        DownloadGifticonEvent(
                          context: context,
                          itemName: itemName,
                          imageUrl: imageUrl,
                          userName: userName,
                          inviteCode: inviteCode,
                        ),
                      ),
              borderRadius: BorderRadius.circular(14),
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: const Color(0xFF1E1626),
                  border: Border.all(
                    color: AppColors.neonPurple.withValues(alpha: 0.4),
                  ),
                ),
                child: Center(
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.neonPurple,
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.file_download_outlined,
                              color: AppColors.neonPurple,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                '이미지 다운로드',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'WantedSans',
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
