import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../application/content_audio/content_audio_bloc.dart';

/// BGM 재생 상태를 제어하는 토글 버튼 위젯.
class ContentAudioToggle extends StatelessWidget {
  const ContentAudioToggle({super.key});

  @override
  Widget build(BuildContext context) {
    // context.watch를 사용하여 BlocBuilder보다 직접적이고 강력하게 상태 변경 구독
    final ContentAudioState audioState = context
        .watch<ContentAudioBloc>()
        .state;
    final ContentAudioBloc audioBloc = context.read<ContentAudioBloc>();

    // URL이 없으면 미표시
    if (audioState.currentUrl == null || audioState.currentUrl!.isEmpty) {
      return const SizedBox.shrink();
    }

    // 2. 일반 BGM ON / OFF 상태의 버튼
    final bool isOn = audioState.isPlaying;

    final Color borderColor = isOn
        ? AppColors.neonPurple
        : Colors.white.withValues(alpha: 0.3);

    final Color contentColor = isOn
        ? AppColors.neonPurple
        : Colors.white.withValues(alpha: 0.35);

    return OutlinedButton.icon(
      onPressed: () => audioBloc.add(const ToggleContentAudio()),
      icon: Icon(
        isOn ? Icons.music_note_rounded : Icons.music_off_rounded,
        size: 16,
        color: contentColor,
      ),
      label: Text(
        isOn ? 'BGM ON' : 'BGM OFF',
        style: TextStyle(
          fontFamily: 'WantedSans',
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: contentColor,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        backgroundColor: Colors.transparent,
        side: BorderSide(color: borderColor, width: 1.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }
}
