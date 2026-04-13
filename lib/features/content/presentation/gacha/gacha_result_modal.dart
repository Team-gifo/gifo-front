import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/gift_image_widget.dart';
import '../../../../core/widgets/shared_confetti_widget.dart';
import '../../../lobby/application/lobby_bloc.dart';
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
    transitionBuilder:
        (
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
    pageBuilder:
        (BuildContext ctx, Animation<double> anim1, Animation<double> anim2) {
          return Stack(
            children: <Widget>[
              // 모달 박스 밖(전체 화면)에서 터지는 폭죽 효과
              const IgnorePointer(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SharedConfettiWidget(autoPlay: true),
                ),
              ),
              _GachaResultModalContent(
                item: item,
                onClose: () {
                  // 모달 닫기
                  Navigator.of(ctx).pop();

                  // 상태 초기화 및 전체화면 로딩 플래그 활성화
                  context.read<GachaBloc>().add(const ClearLastDrawnItem());

                  // 백그라운드에서 로비 데이터 갱신
                  context.read<LobbyBloc>().add(SilentRefreshLobbyData());
                },
              ),
            ],
          );
        },
  );
}

class _GachaResultModalContent extends StatelessWidget {
  final GachaItem item;
  final VoidCallback onClose;

  const _GachaResultModalContent({required this.item, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 768;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: SingleChildScrollView(
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 28, 28, 28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: isDesktop ? 400 : 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.neonPurple.withValues(alpha: 0.25),
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: GiftImageWidget(
                          imageUrl: item.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: isDesktop ? 400 : 300,
                        ),
                      ),
                      const SizedBox(height: 20),
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
      ),
    );
  }
}
