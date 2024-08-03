import 'package:dartz/dartz.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marshal/data/models/song_model.dart';
import 'package:marshal/domain/repository/shared_song_repo.dart';

abstract class SongRepo {
  Future<Option> getNewReleseas();
  Future<List<String>> generateCoverUrls(SharedSongRepo sharedSongrepo);
  Future<List<String>> generateSongUrls(SharedSongRepo sharedSongRepo);
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
