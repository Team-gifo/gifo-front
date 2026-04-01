import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/gacha_setting/gacha_setting_bloc.dart';

class GachaSettingsPanel extends StatelessWidget {
  const GachaSettingsPanel({
    super.key,
    required this.isMobile,
    required this.playCountController,
    required this.canComplete,
    required this.onComplete,
  });

  final bool isMobile;
  final TextEditingController playCountController;
  final bool canComplete;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (!isMobile) const SizedBox(height: 24),
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
        const SizedBox(height: 40),
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
                child: BlocBuilder<GachaSettingBloc, GachaSettingState>(
                  builder: (BuildContext context, GachaSettingState state) =>
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            dropdownColor: const Color(0xFF1A1A1A),
                            style: const TextStyle(color: Colors.white),
                            iconEnabledColor: Colors.white38,
                            value: state.selectedBgm,
                            isExpanded: true,
                            onChanged: (String? val) {
                              if (val != null) {
                                context.read<GachaSettingBloc>().add(
                                  UpdateBgm(val),
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
        if (!isMobile) ...<Widget>[
          const Spacer(),
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
                Text(
                  '• 캡슐 최소 1개 이상 생성',
                  style: TextStyle(fontSize: 16, color: Colors.white54),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  '• 상단 이름 및 서브타이틀 입력',
                  style: TextStyle(fontSize: 16, color: Colors.white54),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  '• 뽑기 가능 횟수 최소 1회 이상',
                  style: TextStyle(fontSize: 16, color: Colors.white54),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  '• 미완성 캡슐 없음',
                  style: TextStyle(fontSize: 16, color: Colors.white54),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  '• 전체 확률 100% 충족',
                  style: TextStyle(fontSize: 16, color: Colors.white54),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 60,
            child: ElevatedButton(
              onPressed: canComplete ? onComplete : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    canComplete ? const Color(0xFF6DE1F1) : Colors.grey.shade300,
                disabledBackgroundColor: Colors.grey.shade800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                '포장 완료',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: canComplete ? Colors.black : Colors.grey.shade500,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
