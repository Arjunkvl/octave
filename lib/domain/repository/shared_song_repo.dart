import 'package:marshal/data/models/song_model.dart';

class SharedSongRepo {
  List<Song> newReleaseList = [];
  List<Song> currentlyPlayingSongList = [];

  List<Song> getSongList() => newReleaseList;
  void updateNewReleaseList(List<Song> songs) {
    newReleaseList.addAll(songs);
  }
}
