import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gifo/core/constants/app_colors.dart';

import '../../../application/bgm_preset/bgm_preset_bloc.dart';
import '../../../model/bgm_preset.dart';

class BgmSelectorWidget extends StatefulWidget {
  const BgmSelectorWidget({
    super.key,
    required this.selectedBgmId,
    required this.onBgmChanged,
    this.isCompactDesktop = false,
  });

  final String selectedBgmId;
  final ValueChanged<String> onBgmChanged;
  final bool isCompactDesktop;

  @override
  State<BgmSelectorWidget> createState() => _BgmSelectorWidgetState();
}

class _BgmSelectorWidgetState extends State<BgmSelectorWidget> {
  bool _autoSelected = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tryAutoSelect();
    });
  }

  @override
  void didUpdateWidget(BgmSelectorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedBgmId != oldWidget.selectedBgmId) {
      _autoSelected = false;
    }
  }

  void _tryAutoSelect() {
    if (_autoSelected || widget.selectedBgmId.isNotEmpty) return;
    final BgmPresetState bgmState = context.read<BgmPresetBloc>().state;
    if (bgmState.isLoaded && bgmState.presets.isNotEmpty) {
      _autoSelected = true;
      widget.onBgmChanged(bgmState.presets.first.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BgmPresetBloc, BgmPresetState>(
      listener: (BuildContext context, BgmPresetState bgmState) {
        if (!_autoSelected &&
            bgmState.isLoaded &&
            bgmState.presets.isNotEmpty &&
            widget.selectedBgmId.isEmpty) {
          _autoSelected = true;
          widget.onBgmChanged(bgmState.presets.first.id);
        }
      },
      builder: (BuildContext context, BgmPresetState bgmState) {
        if (!bgmState.isLoaded) {
          return Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    '로딩 중...',
                    style: TextStyle(color: Colors.white38, fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _buildPlayButton(bgmState, null),
            ],
          );
        }

        final List<BgmPreset> presets = bgmState.presets;
        final bool hasValidSelection = presets.any(
          (BgmPreset p) => p.id == widget.selectedBgmId,
        );
        final String effectiveValue = hasValidSelection
            ? widget.selectedBgmId
            : (presets.isNotEmpty ? presets.first.id : '');

        return Row(
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
                    value: effectiveValue.isEmpty ? null : effectiveValue,
                    isExpanded: true,
                    dropdownColor: const Color(0xFF1A1A1A),
                    style: const TextStyle(color: Colors.white),
                    iconEnabledColor: Colors.white38,
                    hint: const Text(
                      'BGM 선택',
                      style: TextStyle(color: Colors.white38),
                    ),
                    onChanged: (String? val) {
                      if (val != null) {
                        widget.onBgmChanged(val);
                      }
                    },
                    items: presets
                        .map(
                          (BgmPreset preset) => DropdownMenuItem<String>(
                            value: preset.id,
                            child: Text(
                              preset.name,
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
            _buildPlayButton(bgmState, effectiveValue),
          ],
        );
      },
    );
  }

  Widget _buildPlayButton(BgmPresetState bgmState, String? currentId) {
    final bool isPlaying =
        currentId != null && bgmState.playingPresetId == currentId;

    final bool canPlay =
        bgmState.isLoaded &&
        !bgmState.isApiFailed &&
        currentId != null &&
        currentId.isNotEmpty;

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: isPlaying
            ? Colors.white.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isPlaying
              ? AppColors.neonPurple.withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: IconButton(
        onPressed: canPlay
            ? () {
                if (isPlaying) {
                  context.read<BgmPresetBloc>().add(StopBgmPreview());
                } else {
                  context.read<BgmPresetBloc>().add(PlayBgmPreview(currentId));
                }
              }
            : null,
        padding: EdgeInsets.zero,
        iconSize: 24,
        color: isPlaying ? AppColors.neonPurple : Colors.white70,
        disabledColor: Colors.white24,
        icon: Icon(isPlaying ? Icons.stop_circle : Icons.play_circle_filled),
        tooltip: isPlaying ? '정지' : '미리듣기',
      ),
    );
  }
}
