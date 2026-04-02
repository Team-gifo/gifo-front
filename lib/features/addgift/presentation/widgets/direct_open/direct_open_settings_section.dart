import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/direct_open_setting/direct_open_setting_bloc.dart';

class DirectOpenSettingsSection extends StatelessWidget {
  const DirectOpenSettingsSection({
    super.key,
    required this.state,
    this.isMobile = false,
  });

  final DirectOpenSettingState state;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'BGM (배경음악)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
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
                    value: state.selectedBgm,
                    isExpanded: true,
                    dropdownColor: const Color(0xFF1A1A1A),
                    style: const TextStyle(color: Colors.white),
                    iconEnabledColor: Colors.white38,
                    onChanged: (String? val) {
                      if (val != null) {
                        context.read<DirectOpenSettingBloc>().add(
                          UpdateDirectOpenBgm(val),
                        );
                      }
                    },
                    items: <String>['신나는 생일', '잔잔한 음악', '우리의 추억']
                        .map(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, overflow: TextOverflow.ellipsis),
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
        if (!isMobile) ...<Widget>[
          const SizedBox(height: 16),
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
                Text('• 상단 닉네임 및 서브타이틀 입력', style: TextStyle(fontSize: 12, color: Colors.white70)),
                Text('• 물품 이름 입력', style: TextStyle(fontSize: 12, color: Colors.white70)),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
