import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/direct_open_setting/direct_open_setting_bloc.dart';
import '../shared/bgm_selector_widget.dart';

class DirectOpenSettingsSection extends StatelessWidget {
  const DirectOpenSettingsSection({
    super.key,
    required this.state,
    this.isMobile = false,
    this.isCompactDesktop = false,
    required this.hasNameAndSubTitle,
    required this.hasBeforeDesc,
    required this.hasItemName,
  });

  final DirectOpenSettingState state;
  final bool isMobile;
  final bool isCompactDesktop;
  final bool hasNameAndSubTitle;
  final bool hasBeforeDesc;
  final bool hasItemName;

  @override
  Widget build(BuildContext context) {
    final double titleFontSize = isCompactDesktop ? 15 : 16;
    final double spacingAfterTitle = isCompactDesktop ? 6 : 8;
    final double spacingBeforeConditions = isCompactDesktop ? 12 : 16;
    final double conditionsPadding = isCompactDesktop ? 14 : 16;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'BGM (배경음악)',
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: spacingAfterTitle),
        BgmSelectorWidget(
          selectedBgmId: state.selectedBgm,
          onBgmChanged: (String id) => context
              .read<DirectOpenSettingBloc>()
              .add(UpdateDirectOpenBgm(id)),
          isCompactDesktop: isCompactDesktop,
        ),
        if (!isMobile) ...<Widget>[
          SizedBox(height: spacingBeforeConditions),
          Container(
            padding: EdgeInsets.all(conditionsPadding),
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
                SizedBox(height: isCompactDesktop ? 6 : 8),
                _buildConditionItem('상단 닉네임 및 서브타이틀 입력', hasNameAndSubTitle, isCompactDesktop),
                _buildConditionItem('개봉 전 설명란 작성', hasBeforeDesc, isCompactDesktop),
                _buildConditionItem('개봉 후 물품 이름 작성', hasItemName, isCompactDesktop),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildConditionItem(String text, bool met, bool isCompactDesktop) {
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
              style: TextStyle(fontSize: textSize, color: met ? Colors.greenAccent : Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
