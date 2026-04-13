import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import 'receiver_name_bottom_button.dart';
import 'receiver_name_input_field.dart';

class ReceiverNameDesktopLayout extends StatelessWidget {
  const ReceiverNameDesktopLayout({
    super.key,
    required this.nameController,
    required this.onNext,
  });

  final TextEditingController nameController;
  final ValueChanged<String> onNext;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 64.0,
                              vertical: 48.0,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '선물 받는 분의',
                                  style: TextStyle(
                                    fontFamily: 'PFStardustS',
                                    fontSize: 36,
                                    color: Colors.white.withValues(alpha: 0.9),
                                    height: 1.4,
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: '닉네임',
                                        style: TextStyle(
                                          fontFamily: 'WantedSans',
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.neonPurple,
                                          height: 1.4,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '을 알려주세요',
                                        style: TextStyle(
                                          fontFamily: 'PFStardustS',
                                          fontSize: 36,
                                          color: Colors.white.withValues(
                                            alpha: 0.9,
                                          ),
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.05),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      const Icon(
                                        Icons.info_outline_rounded,
                                        size: 18,
                                        color: Colors.yellow,
                                      ),
                                      const SizedBox(width: 10),
                                      Flexible(
                                        child: Text(
                                          '선물 오픈 시 사용되는 명칭이니 참고해 주세요.',
                                          style: TextStyle(
                                            fontFamily: 'WantedSans',
                                            fontSize: 14,
                                            color: Colors.yellow.withValues(
                                              alpha: 0.8,
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
                        Expanded(
                          child: Center(
                            child: SizedBox(
                              width: 400,
                              child: ReceiverNameInputField(
                                controller: nameController,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 데스크탑에서는 컬럼 하단 우측에 버튼 배치
                  Padding(
                    padding: const EdgeInsets.only(right: 40.0, bottom: 40.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 1000,
                          minWidth: 300,
                        ),
                        child: ReceiverNameBottomButton(
                          nameController: nameController,
                          onNext: onNext,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
