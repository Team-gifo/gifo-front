import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../application/content_audio/content_audio_bloc.dart';

class ContentAudioToggle extends StatelessWidget {
  const ContentAudioToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContentAudioBloc, ContentAudioState>(
      builder: (BuildContext context, ContentAudioState state) {
        // 재생할 URL이 없는 경우(데이터 로드 전 등) 아이콘 미표시
        if (state.currentUrl == null || state.currentUrl!.isEmpty) {
          return const SizedBox.shrink();
        }

        final bool isMuted = state.isMuted;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: IconButton(
            onPressed: () {
              context.read<ContentAudioBloc>().add(const ToggleContentAudio());
            },
            icon: Icon(
              isMuted ? Icons.music_off_rounded : Icons.music_note_rounded,
              color: isMuted ? Colors.white38 : AppColors.neonPurple,
              size: 24,
            ),
            tooltip: isMuted ? 'BGM 켜기' : 'BGM 끄기',
          ),
        );
      },
    );
  }
}
