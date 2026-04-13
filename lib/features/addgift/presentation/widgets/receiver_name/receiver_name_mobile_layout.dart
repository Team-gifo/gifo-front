import 'package:flutter/material.dart';
import 'package:gifo/core/constants/app_colors.dart';

import 'receiver_name_bottom_button.dart';
import 'receiver_name_input_field.dart';

class ReceiverNameMobileLayout extends StatelessWidget {
  const ReceiverNameMobileLayout({
    super.key,
    required this.isMobile,
    required this.isTablet,
    required this.nameController,
    required this.onNext,
  });

  final bool isMobile;
  final bool isTablet;
  final TextEditingController nameController;
  final ValueChanged<String> onNext;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 24.0 : 48.0,
                vertical: 32.0,
              ),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(height: 24),
                    Text(
                      '선물 받는 분의',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'PFStardustS',
                        fontSize: isMobile ? 28 : 30,
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '닉네임',
                            style: TextStyle(
                              fontFamily: 'WantedSans',
                              fontSize: isMobile ? 28 : 30,
                              fontWeight: FontWeight.bold,
                              color: AppColors.neonPurple,
                              height: 1.4,
                            ),
                          ),
                          TextSpan(
                            text: '을 알려주세요',
                            style: TextStyle(
                              fontFamily: 'PFStardustS',
                              fontSize: isMobile ? 28 : 30,
                              color: Colors.white.withValues(alpha: 0.9),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Center(
                      child: SizedBox(
                        width: isMobile ? double.infinity : 400,
                        child: Column(
                          children: <Widget>[
                            ReceiverNameInputField(controller: nameController),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const Icon(
                                    Icons.info_outline_rounded,
                                    size: 14,
                                    color: Colors.yellow,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      '선물 오픈 시 사용되는 명칭이니 참고해 주세요.',
                                      style: TextStyle(
                                        fontFamily: 'WantedSans',
                                        fontSize: 12,
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
                    const Spacer(),
                    // 태블릿 버전에서만 컬럼 하단에 버튼 직접 배치
                    // (모바일은 스캐폴드의 bottomNavigationBar 사용)
                    if (isTablet) ...<Widget>[
                      const SizedBox(height: 40),
                      Center(
                        child: SizedBox(
                          width: 448,
                          child: ReceiverNameBottomButton(
                            nameController: nameController,
                            onNext: onNext,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
