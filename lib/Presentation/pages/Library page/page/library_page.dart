import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marshal/Presentation/pages/Home%20Page/bloc/Play%20Song%20Cubit/play_song_cubit.dart';
import 'package:marshal/Presentation/pages/Library%20page/bloc/Library%20Bloc/library_bloc.dart';
import 'package:marshal/Presentation/pages/Library%20page/helpers/variables.dart';
import 'package:marshal/Presentation/pages/Main%20Home%20Page/bloc/BottomNavCubit/bottom_nav_cubit.dart';
import 'package:marshal/data/models/PlayList%20Model/playlist_model.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!isPlayListFetched) {
      context.read<LibraryBloc>().add(GetPlayListsEvent());
      isPlayListFetched = true;
    }
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            flexibleSpace: Container(
              color: Colors.black,
            ),
            pinned: true,
            title: Text(
              'Library',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            actions: [
              SizedBox(
                width: 20.w,
              ),
              IconButton(
                onPressed: () {
                  context.read<PlaySongCubit>().showPlayListAdd();
                },
                icon: Icon(
                  CupertinoIcons.add,
                  color: Colors.white,
                ),
              )
            ],
            backgroundColor: Colors.transparent,
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 30,
            ),
          ),
          BlocBuilder<LibraryBloc, LibraryState>(builder: (context, state) {
            if (state is LibraryLoaded) {
              return SliverToBoxAdapter(
                child: RefreshIndicator(
                  color: Colors.white,
                  onRefresh: () async {
                    await Future.delayed(Duration(milliseconds: 600));
                    if (context.mounted) {
                      context.read<LibraryBloc>().add(GetPlayListsEvent());
                    }
                  },
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: state.playLists.length,
                    itemBuilder: (context, index) => Center(
                        child: GestureDetector(
                      onTap: () {
                        context
                            .read<BottomNavCubit>()
                            .showPlayListPage(playList: state.playLists[index]);
                      },
                      child: PlayListTile(
                        playlist: state.playLists[index],
                      ),
                    )),
                    separatorBuilder: (context, index) => SizedBox(
                      height: 50,
                    ),
                  ),
                ),
              );
            } else {
              return SliverToBoxAdapter(
                child: SizedBox.shrink(),
              );
            }
          })
        ],
      ),
    );
  }
}

class PlayListTile extends StatelessWidget {
  final Playlist playlist;
  const PlayListTile({
    super.key,
    required this.playlist,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (dir) {
        context
            .read<LibraryBloc>()
            .add(RemovePlayListEvent(title: playlist.title));
      },
      key: Key(playlist.title),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Container(
            decoration: BoxDecoration(
              color: CupertinoColors.activeOrange,
              image: playlist.songs.isNotEmpty
                  ? DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                          playlist.songs.first.coverUrl))
                  : null,
              borderRadius: BorderRadius.circular(25),
            ),
            width: 340.w,
            height: 110.h,
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0x64000000),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            width: 160.w,
            height: 40.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  playlist.title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
