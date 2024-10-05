import 'package:dartz/dartz.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marshal/data/models/Category%20model/category_model.dart';
import 'package:marshal/data/models/song_model.dart';
import 'package:marshal/domain/repository/shared_song_repo.dart';

abstract class SongRepo {
  Future<Option<List<Category>>> getCategories({String lastSong = ''});
  Future<Option<List<Song>>> getRecentSongs({String lastSong = ''});
  AudioSource addSongstoPlayList(
      {required String url,
      required String coverUrl,
      required Song song,
      required SharedSongRepo sharedSongRepo});
  // Future<Option> getSongs();
  // Future<void> getRecentSongs() async {}
  // Future<void> updateRecentSongs() async {}
  // Future<void> updateLikedSongs() async {}
  // Future<void> updatePlayedSongs() async {}
}
