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
                    context: context,
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
                    context: context,
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
        const SizedBox(height: 16),
        if (!isMobile)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '⚠️ 포장 완료 조건',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.deepOrange,
                  ),
                ),
                SizedBox(height: 8),
                Text('• 문제 최소 1개 이상 생성', style: TextStyle(fontSize: 12, color: Colors.white70)),
                Text('• 상단 닉네임 및 서브타이틀 입력', style: TextStyle(fontSize: 12, color: Colors.white70)),
                Text('• 미완성 문제 없음 (제목 + 정답 필수)', style: TextStyle(fontSize: 12, color: Colors.white70)),
                Text('• 성공 보상 물품 이름 입력', style: TextStyle(fontSize: 12, color: Colors.white70)),
              ],
            ),
          ),
        const SizedBox(height: 16),
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
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
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
        ),
      ],
    );
  }

  Widget _buildRewardImagePicker({
    required BuildContext context,
    required XFile? imageFile,
    required VoidCallback onTap,
  }) {
    return Stack(
      children: <Widget>[
        InkWell(
          onTap: onTap,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(8),
                image: imageFile != null
                    ? DecorationImage(
                        image: NetworkImage(imageFile.path),
                        fit: BoxFit.contain,
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
          ),
        ),
        if (imageFile != null)
          Positioned(
            top: 8,
            right: 8,
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

void _showFullImage(BuildContext context, XFile imageFile) {
  showDialog<void>(
    context: context,
    builder: (BuildContext ctx) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Stack(
        children: <Widget>[
          InteractiveViewer(
            child: Image.network(
              imageFile.path,
              fit: BoxFit.contain,
            ),
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
