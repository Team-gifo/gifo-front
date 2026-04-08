import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/gacha_setting/gacha_setting_bloc.dart';
import '../shared/bgm_selector_widget.dart';

class GachaSettingsPanel extends StatelessWidget {
  const GachaSettingsPanel({
    super.key,
    required this.isMobile,
    required this.playCountController,
    this.isCompactDesktop = false,
  });

  final bool isMobile;
  final TextEditingController playCountController;
  final bool isCompactDesktop;

  @override
  Widget build(BuildContext context) {
    final double desktopTopSpacing = !isMobile
        ? (isCompactDesktop ? 12 : 24)
        : 0;
    final double sectionGap = isCompactDesktop ? 24 : 40;
    final double bgmVerticalPadding = isCompactDesktop ? 12 : 16;
    final double conditionTitleGap = isCompactDesktop ? 6 : 8;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (!isMobile) SizedBox(height: desktopTopSpacing),
        Row(
          children: <Widget>[
            const Icon(Icons.casino, size: 20, color: Colors.white),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                '뽑기 가능 횟수',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 70,
              child: TextFormField(
                controller: playCountController,
                textAlign: TextAlign.right,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white12,
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xFF6DE1F1),
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xFF6DE1F1),
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              '회',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        BlocBuilder<GachaSettingBloc, GachaSettingState>(
          builder: (BuildContext context, GachaSettingState state) => Text(
            '최대 ${state.uiItems.length}회 설정 가능 (캡슐 개수 기준)',
            style: const TextStyle(fontSize: 12, color: Colors.white38),
            textAlign: TextAlign.end,
          ),
        ),
        SizedBox(height: sectionGap),
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
        Padding(
          padding: EdgeInsets.symmetric(vertical: bgmVerticalPadding),
          child: BlocBuilder<GachaSettingBloc, GachaSettingState>(
            builder: (BuildContext context, GachaSettingState state) =>
                BgmSelectorWidget(
                  selectedBgmId: state.selectedBgm,
                  onBgmChanged: (String id) =>
                      context.read<GachaSettingBloc>().add(UpdateBgm(id)),
                ),
          ),
        ),
        if (!isMobile) ...<Widget>[
          SizedBox(height: isCompactDesktop ? 12 : 16),
          Container(
            padding: EdgeInsets.all(isCompactDesktop ? 14 : 16),
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
                SizedBox(height: conditionTitleGap),
                _buildConditionItem('캡슐 최소 1개 이상 생성', isCompactDesktop),
                _buildConditionItem('상단 이름 및 서브타이틀 입력', isCompactDesktop),
                _buildConditionItem('뽑기 가능 횟수 최소 1회 이상', isCompactDesktop),
                _buildConditionItem('미완성 캡슐 없음', isCompactDesktop),
                _buildConditionItem('전체 확률 100% 충족', isCompactDesktop),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildConditionItem(String text, bool isCompactDesktop) {
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
            color: Colors.white38,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: textSize, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
