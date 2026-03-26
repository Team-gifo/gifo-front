import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gifo/features/addgift/model/gallery_item.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_breakpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../application/gift_packaging_bloc.dart';
import '../widgets/addgift_scaffold.dart';

class MemoryDecisionView extends StatelessWidget {
  const MemoryDecisionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Title(
      title: '선물 포장하기 - Gifo',
      color: AppColors.darkBg,
      child: AddgiftScaffold(
        appBar: AppBar(
          toolbarHeight: 68,
          backgroundColor: AppColors.darkBg,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/');
              }
            },
          ),
          actions: <Widget>[_buildStepIndicator()],
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool isDesktop =
                  constraints.maxWidth >= AppBreakpoints.tablet;
              if (isDesktop) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 24.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: _buildMainText(TextAlign.left),
                        ),
                        const SizedBox(width: 80),
                        Expanded(child: _buildButtonsColumn(context)),
                      ],
                    ),
                  ),
                );
              }
              return CustomScrollView(
                slivers: <Widget>[
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const SizedBox(height: 48),
                          _buildMainText(TextAlign.center),
                          const Spacer(),
                          const SizedBox(height: 48),
                          _buildButtonsColumn(context),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMainText(TextAlign alignment) {
    return Text(
      '선물을 공개하기 전,\n친구와 추억을 공유할까요?',
      textAlign: alignment,
      style: const TextStyle(
        fontFamily: 'PFStardustS',
        fontSize: 28,
        color: Colors.white,
        height: 1.5,
      ),
    );
  }

  Widget _buildButtonsColumn(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildSelectionButton(
          title: '네,',
          subtitle: '저는 친구와 함께 추억을 공유하고 싶어요!',
          icon: Icons.photo_library_rounded,
          accentColor: AppColors.neonPurple,
          onPressed: () => context.push('/addgift/memory-gallery'),
        ),
        const SizedBox(height: 16),
        _buildSelectionButton(
          title: '아니요,',
          subtitle: '저는 바로 선물을 공개할거에요.',
          icon: Icons.card_giftcard_rounded,
          accentColor: AppColors.neonBlue,
          onPressed: () async {
            final bool hasGalleryData = context
                .read<GiftPackagingBloc>()
                .state
                .gallery
                .isNotEmpty;

            if (hasGalleryData) {
              final bool? confirm = await showDialog<bool>(
                context: context,
                builder: (BuildContext dialogContext) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: const Color(0xFF1A1A1A),
                  title: const Text(
                    '추억 갤러리 데이터 존재',
                    style: TextStyle(
                      fontFamily: 'WantedSans',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  content: const Text(
                    '등록된 추억 갤러리 데이터가 있습니다.\n초기화하고 바로 선물 공개로 진행할까요?',
                    style: TextStyle(
                      fontFamily: 'WantedSans',
                      height: 1.5,
                      fontSize: 15,
                      color: Colors.white70,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(false),
                      child: const Text(
                        '아니오 (데이터 유지)',
                        style: TextStyle(
                          fontFamily: 'WantedSans',
                          color: Colors.white38,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(true),
                      child: const Text(
                        '초기화 후 진행',
                        style: TextStyle(
                          fontFamily: 'WantedSans',
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
              if (confirm == true && context.mounted) {
                context.read<GiftPackagingBloc>().add(
                  SetGalleryItems(<GalleryItem>[]),
                );
                context.push('/addgift/delivery-method');
              } else if (confirm == false && context.mounted) {
                context.push('/addgift/delivery-method');
              }
            } else {
              context.push('/addgift/delivery-method');
            }
          },
        ),
      ],
    );
  }

  Widget _buildSelectionButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color accentColor,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 28.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.07),
            border: Border.all(
              color: accentColor.withValues(alpha: 0.5),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: 48, color: accentColor),
              const SizedBox(height: 20),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'PFStardustS',
                  fontSize: 22,
                  color: accentColor,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'WantedSans',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                  color: Colors.white60,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildCircle(isActive: true, number: '1'),
          _buildLine(isActive: true),
          _buildCircle(isActive: true, number: '2'),
          _buildLine(isActive: false),
          _buildCircle(isActive: false, number: '3'),
        ],
      ),
    );
  }

  Widget _buildCircle({required bool isActive, required String number}) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? AppColors.neonPurple : Colors.white12,
        border: isActive ? null : Border.all(color: Colors.white24),
      ),
      child: Center(
        child: Text(
          number,
          style: TextStyle(
            fontFamily: 'WantedSans',
            color: isActive ? Colors.white : Colors.white38,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLine({required bool isActive}) {
    return Container(
      width: 16,
      height: 2,
      color: isActive ? AppColors.neonPurple.withValues(alpha: 0.5) : Colors.white12,
    );
  }
}
