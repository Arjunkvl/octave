import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marshal/Presentation/pages/Home%20Page/widgets/song_list_view_tile.dart';
import 'package:marshal/data/models/song_model.dart';

class BodyListView extends StatelessWidget {
  final List<Song> songs;
  final List<String> coverUrlList;
  const BodyListView({
    super.key,
    required this.songs,
    required this.coverUrlList,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 200,
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: songs.length,
          separatorBuilder: (context, index) => SizedBox(
            width: 10.w,
          ),
          itemBuilder: (context, index) => SongListViewTile(
            song: songs[index],
            index: index,
            coverUrl: coverUrlList[index],
          ),
        ),
      ),
    );
  }
}
