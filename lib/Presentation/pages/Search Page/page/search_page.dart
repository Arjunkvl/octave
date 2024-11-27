import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marshal/Presentation/core/colors.dart';
import 'package:marshal/Presentation/pages/Home%20Page/bloc/Play%20Song%20Cubit/play_song_cubit.dart';
import 'package:marshal/Presentation/pages/Main%20Home%20Page/bloc/Player%20Controller%20Cubit/player_controller_cubit.dart';
import 'package:marshal/Presentation/pages/Playing%20page/bloc/PlayingPageBloc/playing_page_bloc.dart';
import 'package:marshal/Presentation/pages/Search%20Page/cubit/Response%20Songs/response_songs_cubit.dart';
import 'package:marshal/data/models/song_model.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(0, 53.h),
          child: const SearchAppBar(),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 25.h,
              ),
              Text(
                "Recent searches",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 15.h,
              ),
              Expanded(
                child: BlocBuilder<ResponseSongsCubit, ResponseSongsState>(
                  builder: (context, state) {
                    if (state is ShowResultState) {
                      return ListView.separated(
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            context
                                .read<PlaySongCubit>()
                                .playSong(song: state.listOfSongs[index]);
                            context.read<PlayingPageBloc>().add(
                                AddSongEvent(song: state.listOfSongs[index]));
                            context
                                .read<PlayerControllerCubit>()
                                .showPlayerController(
                                    song: state.listOfSongs[index]);
                          },
                          child: SearchTile(
                            song: state.listOfSongs[index],
                          ),
                        ),
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 15,
                        ),
                        itemCount: state.listOfSongs.length,
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchAppBar extends StatelessWidget {
  const SearchAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      height: 53.h,
      color: kbackGroundGrey,
      child: Row(
        children: [
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: TextField(
              onChanged: (query) {
                context.read<ResponseSongsCubit>().trySearching(query: query);
              },
              style: Theme.of(context).textTheme.displayLarge,
              decoration: InputDecoration.collapsed(
                  hintText: 'What do you what to listen to?'),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchTile extends StatelessWidget {
  final Song song;
  const SearchTile({super.key, required this.song});

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
      ],
    );
  }
}
