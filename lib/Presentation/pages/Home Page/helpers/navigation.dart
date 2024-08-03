import 'package:flutter/material.dart';
import 'package:marshal/Presentation/pages/Playing%20page/page/playing_page.dart';
import 'package:marshal/data/models/song_model.dart';

void goToPlayingPage(context,
    {required Song song, required String url, required int index}) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => PlayingPage(
        song: song,
        url: url,
        index: index,
      ),
    ),
  );
}
