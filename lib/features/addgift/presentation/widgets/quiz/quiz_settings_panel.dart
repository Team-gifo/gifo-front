import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../application/quiz_setting/quiz_setting_bloc.dart';
import '../../../model/quiz_setting_models.dart';

class QuizSettingsPanel extends StatelessWidget {
  const QuizSettingsPanel({
    super.key,
    required this.quizState,
    required this.isMobile,
    required this.successRewardNameController,
    required this.failRewardNameController,
    required this.onPickSuccessRewardImage,
    required this.onPickFailRewardImage,
  });

  final QuizSettingState quizState;
  final bool isMobile;
  final TextEditingController successRewardNameController;
  final TextEditingController failRewardNameController;
  final VoidCallback onPickSuccessRewardImage;
  final VoidCallback onPickFailRewardImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (!isMobile) const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  const Text(
                    '맞춘 문제가 ',
                    style: TextStyle(
                      fontSize: 18,
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
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        size: 20,
                        color: Colors.white38,
                      ),
                      items: List<int>.generate(
                            quizState.uiItems.isEmpty
                                ? 1
                                : quizState.uiItems.length,
                            (int index) => index + 1,
                          )
                          .map(
                            (int value) => DropdownMenuItem<int>(
                              value: value,
                              child: Text('$value개'),
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
                                      itemName:
                                          quizState.successReward.itemName,
                                      imageFile:
                                          quizState.successReward.imageFile,
                                    ),
                                  ),
                                );
                              }
                            },
                    ),
                  ),
                  const Text(
                    ' 일 때',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildRewardImagePicker(
                    isSuccess: true,
                    imageFile: quizState.successReward.imageFile,
                    onTap: onPickSuccessRewardImage,
                  ),
                  const SizedBox(height: 16),
                  _buildRewardNameInput(
                    controller: successRewardNameController,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                '그 외 (실패 보상 등)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildRewardImagePicker(
                    isSuccess: false,
                    imageFile: quizState.failReward.imageFile,
                    onTap: onPickFailRewardImage,
                  ),
                  const SizedBox(height: 16),
                  _buildRewardNameInput(
                    controller: failRewardNameController,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        const Text(
          'BGM 설정',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.12),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                '메인 BGM :',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 12),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: quizState.selectedBgm,
                          isExpanded: true,
                          dropdownColor: const Color(0xFF1A1A1A),
                          style: const TextStyle(color: Colors.white),
                          iconEnabledColor: Colors.white38,
                          onChanged: (String? val) {
                            if (val != null) {
                              context.read<QuizSettingBloc>().add(
                                UpdateQuizBgm(val),
                              );
                            }
                          },
                          items: <String>['신나는 생일', '잔잔한 음악', '우리의 추억']
                              .map(
                                (String value) => DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.play_arrow, color: Colors.white38),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRewardImagePicker({
    required bool isSuccess,
    required XFile? imageFile,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(8),
          image: imageFile != null
              ? DecorationImage(
                  image: NetworkImage(imageFile.path),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: imageFile == null
            ? const Center(
                child: Text(
                  '물품 사진',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildRewardNameInput({required TextEditingController controller}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: '물품 이름',
        filled: true,
        fillColor: Colors.white12,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
