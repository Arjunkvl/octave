import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marshal/Presentation/core/colors.dart';
import 'package:marshal/Presentation/pages/Home%20Page/bloc/Play%20Song%20Cubit/play_song_cubit.dart';
import 'package:marshal/Presentation/pages/Main%20Home%20Page/bloc/Player%20Controller%20Cubit/player_controller_cubit.dart';
import 'package:marshal/data/models/song_model.dart';

class RecentWidgetAtTop extends StatelessWidget {
  final Song song;
  const RecentWidgetAtTop({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<PlaySongCubit>().playSong(song: song);
        context.read<PlayerControllerCubit>().showPlayerController(song: song);
      },
      child: Container(
        width: 166.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: kbackGroundGrey,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: CachedNetworkImageProvider(song.coverUrl),
                    fit: BoxFit.cover),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(3),
                  bottomLeft: Radius.circular(3),
                ),
              ),
              width: 40.h,
              height: 40.h,
            ),
            SizedBox(
              width: 10.w,
            ),
            SizedBox(
              width: 100,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  song.title,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
