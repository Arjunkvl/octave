import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marshal/Presentation/Icons/icon_data.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:marshal/Presentation/pages/Playing%20page/bloc/Playing%20Page%20Components/playing_page_components_cubit.dart';
import 'package:marshal/Presentation/pages/Playing%20page/bloc/PlayingPageBloc/playing_page_bloc.dart';
import 'package:marshal/Presentation/pages/Playing%20page/helpers/change_notifier.dart';
import 'package:marshal/data/models/song_model.dart';

class PlayingPage extends StatefulWidget {
  final Song song;

  const PlayingPage({
    super.key,
    required this.song,
  });

  @override
  State<PlayingPage> createState() => _PlayingPageState();
}

class _PlayingPageState extends State<PlayingPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    context.read<PlayingPageBloc>().add(
          LoadSongEvent(song: widget.song),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
        ),
        BlocBuilder<PlayingPageComponentsCubit, PlayingPageComponentsState>(
          builder: (context, state) {
            if (state is SongComponentsState) {
              return Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 30.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: SvgPicture.asset(
                            AppIcons.downArrow,
                            width: 25,
                          ),
                        ),
                        Text(
                          'From ${state.song.artist}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        SvgPicture.asset(AppIcons.threeDot),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 25.w,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 68.h,
                        ),
                        Container(
                          width: 310.w,
                          height: 310.w,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  state.song.coverUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 90.h),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    state.song.title,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                Visibility(
                                    visible: false,
                                    child: SvgPicture.asset(AppIcons.fav)),
                              ],
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            BlocBuilder<PlayingPageBloc, PlayingPageState>(
                              builder: (context, state) {
                                if (state is UpdatedPlayerBar) {
                                  return ProgressBar(
                                    barHeight: 3,
                                    thumbRadius: 7,
                                    thumbGlowRadius: 10,
                                    timeLabelTextStyle:
                                        Theme.of(context).textTheme.bodyMedium,
                                    progressBarColor: Colors.white,
                                    baseBarColor: const Color(0xff766E6E),
                                    bufferedBarColor: Colors.transparent,
                                    thumbColor: const Color(0xffffffff),
                                    thumbGlowColor: const Color(0xDAFFFFFF),
                                    progress:
                                        state.playerDetailsEntitiy.progress,
                                    total: state
                                        .playerDetailsEntitiy.totalDuration,
                                    onSeek: (value) {
                                      context
                                          .read<PlayingPageBloc>()
                                          .add(SeekEvent(progress: value));
                                    },
                                  );
                                } else {
                                  return ProgressBar(
                                    barHeight: 3,
                                    thumbRadius: 7,
                                    thumbGlowRadius: 10,
                                    timeLabelTextStyle:
                                        Theme.of(context).textTheme.bodyMedium,
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
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      context
                                          .read<PlayingPageBloc>()
                                          .add(SkipPreviousEvent());
                                    },
                                    child: SvgPicture.asset(
                                        AppIcons.skipPrevious)),
                                Container(
                                  width: 50.w,
                                  height: 50.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.white,
                                  ),
                                  child: Center(
                                    child: IconButton(
                                      color: Colors.black,
                                      onPressed: () {
                                        if (isPlaying.value) {
                                          // Only dispatch PauseSongEvent if the song is currently playing

                                          context
                                              .read<PlayingPageBloc>()
                                              .add(PauseSongEvent());
                                          // Update state after dispatching
                                          isPlaying.value = false;
                                        } else {
                                          // Only dispatch PlaySongEvent if the song is currently paused
                                          context
                                              .read<PlayingPageBloc>()
                                              .add(PlaySongEvent());
                                          // Update state after dispatching
                                          isPlaying.value = true;
                                        }
                                      },
                                      icon: ValueListenableBuilder(
                                          valueListenable: isPlaying,
                                          builder: (context, value, _) {
                                            return Icon(
                                              size: 30,
                                              value
                                                  ? Icons.pause
                                                  : Icons.play_arrow,
                                            );
                                          }),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      context
                                          .read<PlayingPageBloc>()
                                          .add(SkipNextEvent());
                                    },
                                    child: SvgPicture.asset(AppIcons.skipNext)),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }
}
