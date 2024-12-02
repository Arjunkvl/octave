import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marshal/Presentation/pages/Home%20Page/bloc/Play%20Song%20Cubit/play_song_cubit.dart';
import 'package:marshal/Presentation/pages/Library%20page/bloc/Library%20Bloc/library_bloc.dart';
import 'package:marshal/Presentation/pages/Main%20Home%20Page/bloc/Player%20Controller%20Cubit/player_controller_cubit.dart';
import 'package:marshal/Presentation/pages/Play%20List%20Page/helpers/cstm_sliver_deligate.dart';
import 'package:marshal/Presentation/pages/Playing%20page/bloc/PlayingPageBloc/playing_page_bloc.dart';
import 'package:marshal/data/models/PlayList%20Model/playlist_model.dart';
import 'package:marshal/data/models/song_model.dart';

class PlayListPage extends StatelessWidget {
  final Playlist playlist;
  const PlayListPage({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(bottom: 70.h),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 256.h,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50)),
                      ),
                    ),
                    Positioned(
                      top: 80.h,
                      child: Container(
                        width: 250.w,
                        height: 250.w,
                        decoration: BoxDecoration(
                          color: CupertinoColors.activeOrange,
                          borderRadius: BorderRadius.circular(15),
                          image: playlist.songs.isNotEmpty
                              ? DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      playlist.songs.first.coverUrl))
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: PlayListPagePresistantDelegate(
                minHeight: 70,
                maxHeight: 120,
                child: SizedBox(
                  height: 100.h,
                  width: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        playlist.title,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          color: Colors.white,
                          Icons.play_circle,
                          size: 60,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SliverList.separated(
              separatorBuilder: (context, index) => SizedBox(
                height: 10.w,
              ),
              itemCount: playlist.songs.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  // context
                  //     .read<LibraryBloc>()
                  //     .add(PlayListToQueue(playlist: playlist));
                  context
                      .read<PlaySongCubit>()
                      .playSong(song: playlist.songs[index]);
                  context
                      .read<PlayingPageBloc>()
                      .add(AddSongEvent(song: playlist.songs[index]));
                  context
                      .read<PlayerControllerCubit>()
                      .showPlayerController(song: playlist.songs[index]);
                },
                child: Tilex(
                  song: playlist.songs[index],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 40.h,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Tilex extends StatelessWidget {
  final Song song;
  const Tilex({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 63.w,
          height: 63.w,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: CachedNetworkImageProvider(song.coverUrl))),
        ),
        SizedBox(
          width: 15.w,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 250,
              child: Text(
                overflow: TextOverflow.ellipsis,
                song.title,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Text(
              song.artist,
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ],
        ),
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.remove_circle_outline,
              color: Colors.white,
            ))
      ],
    );
  }
}
