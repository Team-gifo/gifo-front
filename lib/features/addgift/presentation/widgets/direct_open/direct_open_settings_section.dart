import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/direct_open_setting/direct_open_setting_bloc.dart';

class DirectOpenSettingsSection extends StatelessWidget {
  const DirectOpenSettingsSection({super.key, required this.state});

  final DirectOpenSettingState state;

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
      ],
    );
  }
}
