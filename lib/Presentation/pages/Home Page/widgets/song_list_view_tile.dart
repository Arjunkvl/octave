import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:marshal/Presentation/pages/Home%20Page/helpers/navigation.dart';
import 'package:marshal/data/models/song_model.dart';

class SongListViewTile extends StatelessWidget {
  final Song song;
  final int index;
  final String coverUrl;
  const SongListViewTile({
    super.key,
    required this.song,
    required this.index,
    required this.coverUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            goToPlayingPage(context, song: song, url: coverUrl, index: index);
          },
          child: Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(coverUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        Text(
          song.name,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        SizedBox(
          width: 120.w,
          child: Text(
            song.author,
            maxLines: 2,
            softWrap: true,
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.start,
          ),
        )
      ],
    );
  }
}
