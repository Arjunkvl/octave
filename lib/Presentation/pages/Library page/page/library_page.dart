import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marshal/Presentation/pages/Home%20Page/bloc/Play%20Song%20Cubit/play_song_cubit.dart';
import 'package:marshal/Presentation/pages/Library%20page/bloc/Library%20Bloc/library_bloc.dart';
import 'package:marshal/application/dependency_injection.dart';
import 'package:marshal/data/models/PlayList%20Model/playlist_model.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<LibraryBloc>().add(GetPlayListsEvent());
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
              return SliverList.separated(
                itemCount: state.playLists.length,
                itemBuilder: (context, index) => Center(
                    child: PlayListTile(
                  playlist: state.playLists[index],
                )),
                separatorBuilder: (context, index) => SizedBox(
                  height: 50,
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
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                      'https://imgs.search.brave.com/KLj4MbSJtC4nOrMk9HiL9Zikmxh2CM7-AfAlDkTvGVA/rs:fit:500:0:0:0/g:ce/aHR0cHM6Ly9zb3Vy/Y2UuYm9vbXBsYXlt/dXNpYy5jb20vZ3Jv/dXAxMC9NMDAvRkUv/NUIvNjI2YWZmZTI5/OTUxNGM5NjhmMzBi/MWY1YzlhODQxNWRf/MzIwXzMyMC5qcGc')),
              borderRadius: BorderRadius.circular(15),
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
