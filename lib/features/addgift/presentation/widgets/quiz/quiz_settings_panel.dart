import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../application/quiz_setting/quiz_setting_bloc.dart';
import '../shared/bgm_selector_widget.dart';
import '../../../model/quiz_setting_models.dart';

class QuizSettingsPanel extends StatelessWidget {
  const QuizSettingsPanel({
    super.key,
    required this.quizState,
    required this.isMobile,
    this.isCompactDesktop = false,
    required this.successRewardNameController,
    required this.failRewardNameController,
    required this.onPickSuccessRewardImage,
    required this.onPickFailRewardImage,
    this.hasItems = false,
    this.hasNameAndSubTitle = false,
    this.hasNoIncompleteItems = false,
    this.hasSuccessRewardName = false,
    this.hasFailRewardName = false,
  });

  final QuizSettingState quizState;
  final bool isMobile;
  final bool isCompactDesktop;
  final TextEditingController successRewardNameController;
  final TextEditingController failRewardNameController;
  final VoidCallback onPickSuccessRewardImage;
  final VoidCallback onPickFailRewardImage;
  final bool hasItems;
  final bool hasNameAndSubTitle;
  final bool hasNoIncompleteItems;
  final bool hasSuccessRewardName;
  final bool hasFailRewardName;

  @override
  Widget build(BuildContext context) {
    final double topSpacing = isCompactDesktop ? 12 : 24;
    final double sectionSpacing = isCompactDesktop ? 12 : 16;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (!isMobile) SizedBox(height: topSpacing),
        _buildSuccessRewardCard(context),
        SizedBox(height: sectionSpacing),
        _buildFailRewardCard(context),
        SizedBox(height: sectionSpacing),
        _buildBgmCard(context),
        if (!isMobile) SizedBox(height: sectionSpacing),
        if (!isMobile) _buildConditionsCard(),
      ],
    );
  }

  Widget _buildSuccessRewardCard(BuildContext context) {
    final double cardPadding = isCompactDesktop ? 16 : 20;
    final double rewardSentenceFontSize = isCompactDesktop ? 14 : 15;
    final double rewardSentenceGap = isCompactDesktop ? 12 : 16;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.07),
          border: Border(
            left: const BorderSide(color: AppColors.neonPurple, width: 4),
            top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
            right: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
            bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.neonPurple.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    size: 16,
                    color: AppColors.neonPurple,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  '성공 보상',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.neonPurpleLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Text(
                  '맞춘 문제가 ',
                  style: TextStyle(
                    fontSize: rewardSentenceFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: quizState.uiItems.isEmpty
                        ? 1
                        : (quizState.successReward.requiredCount! >
                                  quizState.uiItems.length
                              ? quizState.uiItems.length
                              : quizState.successReward.requiredCount),
                    alignment: Alignment.center,
                    style: TextStyle(
                      fontSize: rewardSentenceFontSize,
                      fontWeight: FontWeight.bold,
                      color: quizState.uiItems.isEmpty
                          ? Colors.white
                          : AppColors.neonPurple,
                    ),
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      size: 18,
                      color: quizState.uiItems.isEmpty
                          ? Colors.white
                          : AppColors.neonPurple,
                    ),
                    items:
                        List<int>.generate(
                              quizState.uiItems.isEmpty
                                  ? 1
                                  : quizState.uiItems.length,
                              (int index) => index + 1,
                            )
                            .map(
                              (int value) => DropdownMenuItem<int>(
                                value: value,
                                child: Text(
                                  '$value개',
                                  style: TextStyle(
                                    color: quizState.uiItems.isEmpty
                                        ? Colors.grey
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: quizState.uiItems.isEmpty
                        ? null
                        : (int? newVal) {
                            if (newVal != null) {
                              context.read<QuizSettingBloc>().add(
                                UpdateSuccessReward(
                                  QuizRewardData(
                                    requiredCount: newVal,
                                    itemName: quizState.successReward.itemName,
                                    imageFile:
                                        quizState.successReward.imageFile,
                                  ),
                                ),
                              );
                            }
                          },
                  ),
                ),
                Text(
                  ' 일 때',
                  style: TextStyle(
                    fontSize: rewardSentenceFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: rewardSentenceGap),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildCompactImagePicker(
                  context: context,
                  imageFile: quizState.successReward.imageFile,
                  onTap: onPickSuccessRewardImage,
                  accentColor: AppColors.neonPurple,
                ),
                SizedBox(width: isCompactDesktop ? 10 : 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        '물품 이름',
                        style: TextStyle(fontSize: 11, color: Colors.white54),
                      ),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: successRewardNameController,
                        decoration: InputDecoration(
                          hintText: '이름 입력',
                          hintStyle: const TextStyle(color: Colors.white38),
                          filled: true,
                          fillColor: Colors.white12,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.neonPurple,
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          suffixIcon: ValueListenableBuilder<TextEditingValue>(
                            valueListenable: successRewardNameController,
                            builder: (context, value, child) {
                              return value.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.white38,
                                      ),
                                      onPressed: () =>
                                          successRewardNameController.clear(),
                                    )
                                  : const SizedBox.shrink();
                            },
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'WantedSans',
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFailRewardCard(BuildContext context) {
    final double cardPadding = isCompactDesktop ? 16 : 20;
    final double rewardTitleFontSize = isCompactDesktop ? 14 : 15;

    final int actualRequired = quizState.uiItems.isEmpty
        ? 1
        : ((quizState.successReward.requiredCount ?? 1) >
                  quizState.uiItems.length
              ? quizState.uiItems.length
              : (quizState.successReward.requiredCount ?? 1));
    final String failConditionText = actualRequired <= 1
        ? '맞춘 문제가 0개 일 때'
        : '맞춘 문제가 0 ~ ${actualRequired - 1}개 일 때';

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          border: Border(
            left: const BorderSide(color: Colors.white38, width: 4),
            top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
            right: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
            bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.sentiment_dissatisfied,
                    size: 16,
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      '실패 보상',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white38,
                      ),
                    ),
                    Text(
                      failConditionText,
                      style: TextStyle(
                        fontSize: rewardTitleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: isCompactDesktop ? 12 : 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildCompactImagePicker(
                  context: context,
                  imageFile: quizState.failReward.imageFile,
                  onTap: onPickFailRewardImage,
                  accentColor: Colors.white38,
                ),
                SizedBox(width: isCompactDesktop ? 10 : 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        '물품 이름',
                        style: TextStyle(fontSize: 11, color: Colors.white54),
                      ),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: failRewardNameController,
                        decoration: InputDecoration(
                          hintText: '이름 입력',
                          hintStyle: const TextStyle(color: Colors.white38),
                          filled: true,
                          fillColor: Colors.white12,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.white38,
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          suffixIcon: ValueListenableBuilder<TextEditingValue>(
                            valueListenable: failRewardNameController,
                            builder: (context, value, child) {
                              return value.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.white38,
                                      ),
                                      onPressed: () =>
                                          failRewardNameController.clear(),
                                    )
                                  : const SizedBox.shrink();
                            },
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'WantedSans',
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactImagePicker({
    required BuildContext context,
    required XFile? imageFile,
    required VoidCallback onTap,
    Color accentColor = Colors.white38,
  }) {
    final double imageSize = isCompactDesktop ? 74 : 90;
    final double iconSize = isCompactDesktop ? 24 : 28;
    final double imageLabelSize = isCompactDesktop ? 9 : 10;

    return Stack(
      children: <Widget>[
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: imageSize,
            height: imageSize,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: imageFile == null
                    ? Border.all(
                        color: accentColor.withValues(alpha: 0.4),
                        width: 1.5,
                      )
                    : null,
                image: imageFile != null
                    ? DecorationImage(
                        image: NetworkImage(imageFile.path),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: imageFile == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.add_photo_alternate,
                          size: iconSize,
                          color: accentColor,
                        ),
                      ],
                    )
                  : null,
            ),
          ),
        ),
        if (imageFile != null)
          Positioned(
            top: 6,
            right: 6,
            child: GestureDetector(
              onTap: () => _showFullImage(context, imageFile),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.open_in_full,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildConditionsCard() {
    final double cardPadding = isCompactDesktop ? 14 : 16;
    final double titleGap = isCompactDesktop ? 8 : 10;

    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Row(
            children: <Widget>[
              Icon(Icons.info_outline, size: 14, color: Colors.orange),
              SizedBox(width: 6),
              Text(
                '포장 완료 조건',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          SizedBox(height: titleGap),
          _buildConditionItem('문제 최소 1개 이상 생성', hasItems),
          _buildConditionItem('상단 닉네임 및 서브타이틀 입력', hasNameAndSubTitle),
          _buildConditionItem('미완성 문제 없음 (제목 + 정답 필수)', hasNoIncompleteItems),
          _buildConditionItem('성공 보상 입력 완료 (이미지, 이름)', hasSuccessRewardName),
          _buildConditionItem('실패 보상 입력 완료 (이미지, 이름)', hasFailRewardName),
        ],
      ),
    );
  }

  Widget _buildConditionItem(String text, bool met) {
    final double itemBottomSpacing = isCompactDesktop ? 4 : 6;
    final double iconSize = isCompactDesktop ? 11 : 12;
    final double textSize = isCompactDesktop ? 12 : 13;

    return Padding(
      padding: EdgeInsets.only(bottom: itemBottomSpacing),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.check_circle_outline,
            size: iconSize,
            color: met ? Colors.greenAccent : Colors.white38,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: textSize,
                color: met ? Colors.greenAccent : Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBgmCard(BuildContext context) {
    final double cardPadding = isCompactDesktop ? 14 : 16;
    final double titleBottomSpacing = isCompactDesktop ? 10 : 12;

    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Row(
            children: <Widget>[
              Icon(Icons.music_note, size: 20, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'BGM 설정',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: titleBottomSpacing),
          BgmSelectorWidget(
            selectedBgmId: quizState.selectedBgm,
            onBgmChanged: (String id) =>
                context.read<QuizSettingBloc>().add(UpdateQuizBgm(id)),
            isCompactDesktop: isCompactDesktop,
          ),
        ],
      ),
    );
  }
}

void _showFullImage(BuildContext context, XFile imageFile) {
  showDialog<void>(
    context: context,
    builder: (BuildContext ctx) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Stack(
        children: <Widget>[
          InteractiveViewer(
            child: Image.network(imageFile.path, fit: BoxFit.contain),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: () => Navigator.of(ctx).pop(),
              icon: const Icon(Icons.close, color: Colors.white),
              style: IconButton.styleFrom(backgroundColor: Colors.black54),
            ),
          ),
        ],
      ),
    ),
  );
}
