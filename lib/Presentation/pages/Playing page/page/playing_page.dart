import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marshal/Presentation/Icons/icon_data.dart';
import 'package:marshal/Presentation/pages/Playing%20page/bloc/PlayingPageBloc/playing_page_bloc.dart';
import 'package:marshal/Presentation/pages/Playing%20page/helpers/button_states.dart';
import 'package:marshal/Presentation/pages/Playing%20page/helpers/change_notifier.dart';
import 'package:marshal/Presentation/pages/Playing%20page/widget/progress_bar.dart';
import 'package:marshal/data/models/song_model.dart';

class PlayingPage extends StatelessWidget {
  final Song song;
  const PlayingPage({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
        ),
        BlocBuilder<PlayingPageBloc, PlayingPageState>(
          builder: (context, state) {
            if (state is PlayingState) {
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
                        Flexible(
                          child: Text(
                            'From ${state.song.artist}',
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
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
                                  width: 200,
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
                            SongProgresssBar(),
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
                                          .add(SkipToPrevious());
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
                                        if (playButtonState.value ==
                                            PlayButtonState.paused) {
                                          context
                                              .read<PlayingPageBloc>()
                                              .add(PauseSongEvent());
                                        }
                                        if (playButtonState.value ==
                                            PlayButtonState.playing) {
                                          context
                                              .read<PlayingPageBloc>()
                                              .add(PlaySongEvent());
                                        }
                                      },
                                      icon: ValueListenableBuilder(
                                          valueListenable: playButtonState,
                                          builder: (context, value, _) {
                                            return switch (value) {
                                              PlayButtonState.loading =>
                                                const CircularProgressIndicator(
                                                  color: Colors.black,
                                                ),
                                              PlayButtonState.playing => Icon(
                                                  Icons.play_arrow,
                                                  size: 30,
                                                  color: Colors.black,
                                                ),
                                              PlayButtonState.paused => Icon(
                                                  Icons.pause,
                                                  size: 30,
                                                  color: Colors.black,
                                                ),
                                            };
                                          }),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      context
                                          .read<PlayingPageBloc>()
                                          .add(SkipToNextEvent());
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
        BlocListener<PlayingPageBloc, PlayingPageState>(
          listener: (context, state) {
            if (state is PlayingPageForceLoadingState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Getting The Link please Wait'),
                  backgroundColor: Colors.white,
                  behavior: SnackBarBehavior.floating,
                  padding: EdgeInsets.all(10),
                ),
              );
            }
          },
          child: SizedBox.shrink(),
        )
      ],
    );
  }
}
