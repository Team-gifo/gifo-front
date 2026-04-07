import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../application/gacha_setting/gacha_setting_bloc.dart';
import '../common/edit_form_styles.dart';

class GachaItemEditForm extends StatelessWidget {
  const GachaItemEditForm({
    super.key,
    required this.modalContext,
    required this.itemData,
    required this.nameController,
    required this.percentController,
    required this.onPickImage,
    required this.onDeleteItem,
  });

  final BuildContext modalContext;
  final DefaultGachaItemData itemData;
  final TextEditingController nameController;
  final TextEditingController percentController;
  final Future<void> Function(DefaultGachaItemData, VoidCallback) onPickImage;
  final ValueChanged<int> onDeleteItem;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setModalState) {
        return BlocBuilder<GachaSettingBloc, GachaSettingState>(
          builder: (BuildContext context, GachaSettingState state) {
            final DefaultGachaItemData currentItemData = state.uiItems
                .firstWhere(
                  (DefaultGachaItemData item) => item.id == itemData.id,
                  orElse: () => itemData,
                );

            void updateModal() {
              setModalState(() {});
            }

            final bool isTitleValid = currentItemData.itemName
                .trim()
                .isNotEmpty;
            final double? percentValue = double.tryParse(
              currentItemData.percentStr,
            );
            final bool isPercentValid =
                percentValue != null &&
                percentValue >= 0.01 &&
                percentValue <= 100.0;

            double sumWithoutCurrent = 0.0;
            for (final DefaultGachaItemData item in state.uiItems) {
              if (item.id != currentItemData.id) {
                sumWithoutCurrent += item.percent;
              }
            }
            double remaining = 100.0 - sumWithoutCurrent;
            if (remaining < 0) remaining = 0.0;

            String formatPercent(double percent) {
              String s = percent.toStringAsFixed(2);
              if (s.endsWith('.00')) return s.substring(0, s.length - 3);
              if (s.endsWith('0')) return s.substring(0, s.length - 1);
              return s;
            }

            final String remainingStr = formatPercent(remaining);

            Widget buildQuickPercentBtn(String value, String label) {
              return TextButton(
                onPressed: () {
                  final String rawValue = value.replaceAll('%', '');
                  percentController.text = rawValue;
                  context.read<GachaSettingBloc>().add(
                    UpdateGachaItemPercent(currentItemData.id, rawValue),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.neonPurple.withValues(alpha: 0.15),
                  foregroundColor: AppColors.neonPurple,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'WantedSans',
                  ),
                ),
              );
            }

            return Container(
              color: EditFormStyles.formBackground,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(
                        left: 24.0,
                        right: 24.0,
                        top: 24.0,
                        bottom: MediaQuery.viewInsetsOf(context).bottom + 24.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          EditFormStyles.dragHandle(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const SizedBox(width: 24),
                              const Text(
                                '캡슐 상세 설정',
                                style: EditFormStyles.headerTitleStyle,
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                                onPressed: () =>
                                    Navigator.of(modalContext).pop(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          EditFormStyles.sectionTitle('제목'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: nameController,
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'WantedSans',
                            ),
                            onChanged: (String val) {
                              context.read<GachaSettingBloc>().add(
                                UpdateGachaItemName(currentItemData.id, val),
                              );
                            },
                            decoration: EditFormStyles.inputDecorationWithValidation(
                              hint: '제목을 입력해주세요',
                              isValid: isTitleValid,
                              errorText: !isTitleValid
                                  ? '제목은 최소 1글자 이상이어야 합니다.'
                                  : null,
                              suffixIcon: currentItemData.itemName.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.clear,
                                        size: 20,
                                        color: Colors.white38,
                                      ),
                                      onPressed: () {
                                        nameController.clear();
                                        context.read<GachaSettingBloc>().add(
                                          UpdateGachaItemName(
                                            currentItemData.id,
                                            '',
                                          ),
                                        );
                                      },
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 16),
                          EditFormStyles.sectionTitle('이미지'),
                          if (currentItemData.imageFile == null)
                            EditFormStyles.emptyImagePicker(
                              onTap: () =>
                                  onPickImage(currentItemData, updateModal),
                            )
                          else
                            EditFormStyles.imagePreviewWithActions(
                              imagePath: currentItemData.imageFile!.path,
                              onEdit: () => onPickImage(
                                currentItemData,
                                updateModal,
                              ),
                              onDelete: () {
                                context.read<GachaSettingBloc>().add(
                                  RemoveGachaItemImage(
                                    currentItemData.id,
                                  ),
                                );
                              },
                            ),
                          const SizedBox(height: 24),
                          const Text(
                            '- 부적절한 제목이나 이미지는 신고 대상이 될 수 있으며, 관련 책임은 등록 주체에게 있음을 알려드립니다.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontFamily: 'WantedSans',
                            ),
                          ),
                          const SizedBox(height: 16),
                          EditFormStyles.sectionTitle('확률 (%)'),
                          TextFormField(
                            controller: percentController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'WantedSans',
                            ),
                            onChanged: (String val) {
                              context.read<GachaSettingBloc>().add(
                                UpdateGachaItemPercent(currentItemData.id, val),
                              );
                            },
                            decoration: EditFormStyles.inputDecorationWithValidation(
                              hint: '확률을 입력해주세요',
                              isValid: isPercentValid,
                              errorText: !isPercentValid
                                  ? '확률은 0.01% 이상 100% 이하입니다.'
                                  : null,
                              suffixIcon: currentItemData.percentStr.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.clear,
                                        size: 20,
                                        color: Colors.white38,
                                      ),
                                      onPressed: () {
                                        percentController.clear();
                                        context.read<GachaSettingBloc>().add(
                                          UpdateGachaItemPercent(
                                            currentItemData.id,
                                            '',
                                          ),
                                        );
                                      },
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: <Widget>[
                              buildQuickPercentBtn(
                                remainingStr,
                                '(남은 확률) $remainingStr%',
                              ),
                              buildQuickPercentBtn('1', '1%'),
                              buildQuickPercentBtn('10', '10%'),
                              buildQuickPercentBtn('50', '50%'),
                              buildQuickPercentBtn('100', '100%'),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: <Widget>[
                              Checkbox(
                                value: currentItemData.percentOpen,
                                onChanged: (bool? val) {
                                  context.read<GachaSettingBloc>().add(
                                    UpdateGachaItemPercentOpen(
                                      currentItemData.id,
                                      val ?? false,
                                    ),
                                  );
                                },
                                activeColor: AppColors.neonPurple,
                              ),
                              const Expanded(
                                child: Text(
                                  '확률 공개 여부',
                                  style: TextStyle(
                                    fontFamily: 'WantedSans',
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            '- 모든 캡슐의 확률 합이 100% 이하여야 합니다.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              fontFamily: 'WantedSans',
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border(
                        top: BorderSide(
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(modalContext).pop();
                              onDeleteItem(currentItemData.id);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.red.shade400,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                  color: Colors.red.shade400,
                                  width: 1.5,
                                ),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              '삭제',
                              style: TextStyle(
                                fontFamily: 'WantedSans',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(modalContext).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.neonPurple,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              '닫기',
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
          );
        },
      );
    },
  );
}
}
