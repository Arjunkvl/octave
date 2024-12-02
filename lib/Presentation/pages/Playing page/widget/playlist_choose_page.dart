import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marshal/Presentation/pages/Library%20page/bloc/Library%20Bloc/library_bloc.dart';
import 'package:marshal/Presentation/pages/Playing%20page/widget/playlist_tile.dart';
import 'package:marshal/data/models/PlayList%20Model/playlist_model.dart';
import 'package:marshal/data/models/song_model.dart';

class PlayListChoosePage extends StatelessWidget {
  final List<Playlist> playList;
  final Song song;
  const PlayListChoosePage({
    super.key,
    required this.playList,
    required this.song,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          color: Colors.black,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 40.h,
            ),
            Text(
              'Choose PlayList',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(
              height: 50.h,
            ),
            ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) => Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                          onTap: () {
                            context.read<LibraryBloc>().add(
                                  AddToPlayListEvent(
                                    playlist: playList[index],
                                    song: song,
                                  ),
                                );
                            Navigator.pop(context);
                          },
                          child: ChoosablePlayList(playlist: playList[index])),
                    ),
                separatorBuilder: (context, index) => SizedBox(
                      height: 20.h,
                    ),
                itemCount: playList.length),
          ],
        )
      ],
    );
  }
}
