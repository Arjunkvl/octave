import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marshal/data/models/PlayList%20Model/playlist_model.dart';

class ChoosablePlayList extends StatelessWidget {
  final Playlist playlist;
  const ChoosablePlayList({
    super.key,
    required this.playlist,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Container(
          decoration: BoxDecoration(
            color: CupertinoColors.activeGreen,
            image: playlist.songs.isNotEmpty
                ? DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                        playlist.songs.first.coverUrl))
                : null,
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
    );
  }
}
