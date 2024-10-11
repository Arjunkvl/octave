import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marshal/Presentation/pages/Home%20Page/bloc/Play%20Song%20Cubit/play_song_cubit.dart';

import 'package:marshal/Presentation/pages/Main%20Home%20Page/bloc/Player%20Controller%20Cubit/player_controller_cubit.dart';
import 'package:marshal/data/models/song_model.dart';

class SongListViewTile extends StatelessWidget {
  final Song song;

  const SongListViewTile({
    super.key,
    required this.song,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async {
            context.read<PlaySongCubit>().playSong(song: song);
            context
                .read<PlayerControllerCubit>()
                .showPlayerController(song: song);
          },
          child: Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(song.coverUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        SizedBox(
          width: 120.w,
          child: Text(
            song.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        SizedBox(
          width: 120.w,
          child: Text(
            song.artist,
            softWrap: true,
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}
