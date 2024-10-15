import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:marshal/Presentation/pages/Playing%20page/bloc/PlayingPageBloc/playing_page_bloc.dart';
import 'package:marshal/Presentation/pages/Playing%20page/bloc/Progress%20Bar/progress_bar_cubit.dart';

class SongProgresssBar extends StatefulWidget {
  const SongProgresssBar({super.key});

  @override
  State<SongProgresssBar> createState() => _SongProgresssBarState();
}

class _SongProgresssBarState extends State<SongProgresssBar>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProgressBarCubit, ProgressBarState>(
      builder: (context, state) {
        if (state is ProgressBarInitial) {
          return ProgressBar(
            barHeight: 3,
            thumbRadius: 7,
            thumbGlowRadius: 10,
            timeLabelTextStyle: Theme.of(context).textTheme.bodyMedium,
            progressBarColor: Colors.white,
            baseBarColor: const Color(0xff766E6E),
            bufferedBarColor: Colors.transparent,
            thumbColor: const Color(0xffffffff),
            thumbGlowColor: const Color(0xDAFFFFFF),
            progress: state.playerBarEntity.currentDuration,
            total: state.playerBarEntity.totalDuration,
            onSeek: (value) {
              context.read<PlayingPageBloc>().add(SeekEvent(position: value));
            },
          );
        } else {
          return ProgressBar(
            barHeight: 3,
            thumbRadius: 7,
            thumbGlowRadius: 10,
            timeLabelTextStyle: Theme.of(context).textTheme.bodyMedium,
            progressBarColor: Colors.white,
            baseBarColor: const Color(0xff766E6E),
            bufferedBarColor: Colors.transparent,
            thumbColor: const Color(0xffffffff),
            thumbGlowColor: const Color(0xDAFFFFFF),
            progress: Duration.zero,
            total: Duration.zero,
          );
        }
      },
    );
  }
}
