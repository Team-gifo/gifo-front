import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gifo/features/addgift/model/gallery_item.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_breakpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../application/gift_packaging_bloc.dart';
import '../widgets/addgift_scaffold.dart';
import '../widgets/memory_decision/memory_decision_buttons_column.dart';
import '../widgets/memory_decision/memory_decision_main_text.dart';
import '../widgets/step_indicator.dart';

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
          actions: const <Widget>[StepIndicator(activeStep: 2)],
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
                        const Expanded(
                          child: MemoryDecisionMainText(
                            alignment: TextAlign.left,
                          ),
                        ),
                        const SizedBox(width: 80),
                        Expanded(
                          child: MemoryDecisionButtonsColumn(
                            onSelectShareMemory: () {
                              unawaited(
                                context.push('/addgift/memory-gallery'),
                              );
                            },
                            onSelectDirectOpen: () =>
                                _handleDirectOpenSelection(context),
                          ),
                        ),
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
                          const MemoryDecisionMainText(
                            alignment: TextAlign.center,
                          ),
                          const Spacer(),
                          const SizedBox(height: 48),
                          MemoryDecisionButtonsColumn(
                            onSelectShareMemory: () {
                              unawaited(
                                context.push('/addgift/memory-gallery'),
                              );
                            },
                            onSelectDirectOpen: () =>
                                _handleDirectOpenSelection(context),
                          ),
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

  Future<void> _handleDirectOpenSelection(BuildContext context) async {
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
        context.read<GiftPackagingBloc>().add(SetGalleryItems(<GalleryItem>[]));
        unawaited(context.push('/addgift/delivery-method'));
      } else if (confirm == false && context.mounted) {
        unawaited(context.push('/addgift/delivery-method'));
      }
      return;
    }

    unawaited(context.push('/addgift/delivery-method'));
  }
}
