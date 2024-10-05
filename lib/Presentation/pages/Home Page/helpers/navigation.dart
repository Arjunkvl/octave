import 'package:flutter/material.dart';
import 'package:marshal/Presentation/pages/Playing%20page/page/playing_page.dart';
import 'package:marshal/data/models/song_model.dart';

void goToPlayingPage(context, {required Song song}) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => PlayingPage(
        song: song,
      ),
    ),
  );
}
