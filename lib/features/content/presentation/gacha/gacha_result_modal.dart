import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/shared_confetti_widget.dart';
import '../../../lobby/model/lobby_data.dart';
import '../../application/gacha/gacha_bloc.dart';

// ==========================================
// 캡슐 뽑기 전용 결과 모달
// - result_view 로 이동하지 않고 인라인 모달로 처리
// - 닫기 시 ClearLastDrawnItem 이벤트 dispatch
// ==========================================

void showGachaResultModal(BuildContext context, GachaItem item) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: '결과 모달',
    barrierColor: Colors.black.withValues(alpha: 0.75),
    transitionDuration: const Duration(milliseconds: 400),
    transitionBuilder: (
      BuildContext ctx,
      Animation<double> anim1,
      Animation<double> anim2,
      Widget child,
    ) {
      return ScaleTransition(
        scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
        child: FadeTransition(opacity: anim1, child: child),
      );
    },
    pageBuilder: (
      BuildContext ctx,
      Animation<double> anim1,
      Animation<double> anim2,
    ) {
      return _GachaResultModalContent(
        item: item,
        onClose: () {
          // 모달 닫기 및 상태 초기화
          Navigator.of(ctx).pop();
          context.read<GachaBloc>().add(const ClearLastDrawnItem());
        },
      );
    },
  );
}

class _GachaResultModalContent extends StatelessWidget {
  final GachaItem item;
  final VoidCallback onClose;

  const _GachaResultModalContent({
    required this.item,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 768;

    return Center(
      child: SingleChildScrollView(
        // 화면 세로가 작은 경우 모달 내용이 잘리지 않도록 스크롤 허용
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: isDesktop ? 120 : 24,
            vertical: 40,
          ),
          constraints: const BoxConstraints(maxWidth: 480),
          decoration: BoxDecoration(
            color: const Color(0xFF130E1F),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.neonPurple.withValues(alpha: 0.5),
              width: 1.5,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: AppColors.neonPurple.withValues(alpha: 0.3),
                blurRadius: 60,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Stack(
            children: <Widget>[
              // 상단 색종이 효과
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SharedConfettiWidget(autoPlay: true),
                  ),
                ),
              ),
              // 본문 콘텐츠
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 28, 28, 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // 당첨 레이블 (pill 뱃지)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.neonPurple.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: AppColors.neonPurple.withValues(alpha: 0.6),
                        ),
                      ),
                      child: const Text(
                        '🎉  CONGRATULATIONS!',
                        style: TextStyle(
                          fontFamily: 'PFStardust',
                          fontSize: 13,
                          color: AppColors.neonPurple,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 경품 이미지 (메인 포커스)
                    Container(
                      width: double.infinity,
                      height: isDesktop ? 240 : 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: const Color(0xFF1E1626),
                        border: Border.all(
                          color: AppColors.neonPurple.withValues(alpha: 0.25),
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: item.imageUrl.startsWith('http')
                          ? Image.network(item.imageUrl, fit: BoxFit.contain)
                          : Image.asset(item.imageUrl, fit: BoxFit.contain),
                    ),
                    const SizedBox(height: 20),

                    // 당첨 결과 레이블 + 아이템명
                    Text(
                      '당첨 결과',
                      style: TextStyle(
                        fontFamily: 'WantedSans',
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.5),
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.itemName,
                      style: const TextStyle(
                        fontFamily: 'WantedSans',
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),

                    // 확인 버튼
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: onClose,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.neonPurple,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          '확인',
                          style: TextStyle(
                            fontFamily: 'WantedSans',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
