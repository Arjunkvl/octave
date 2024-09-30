import 'package:dartz/dartz.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marshal/data/models/song_model.dart';
import 'package:marshal/data/repository/song_repo_impl.dart';
import 'package:marshal/domain/repository/shared_song_repo.dart';

class GetNewReleseas {
  final SongRepoImpl repository;

  GetNewReleseas({required this.repository});
  Future<Option<List<Song>>> call({String lastSong = ''}) async {
    return await repository.getNewReleseas(lastSong: lastSong);
  }
}

class GetRecentSongs {
  final SongRepoImpl repository;

  GetRecentSongs({required this.repository});
  Future<Option<List<Song>>> call({String lastSong = ''}) async {
    return await repository.getRecentSongs(lastSong: lastSong);
  }
}
// class GenerateSongUrls {
//   final SongRepoImpl repository;

//   GenerateSongUrls({required this.repository});
//   Future<List<String>> call(SharedSongRepo sharedSongRepo) async {
//     return await repository.generateSongUrls(sharedSongRepo);
//   }
// }

class AddSongstoPlayList {
  final SongRepoImpl repository;

  AddSongstoPlayList({required this.repository});
  AudioSource call(
      {required String url,
      required String coverUrl,
      required Song song,
      required SharedSongRepo sharedSongRepo}) {
    return repository.addSongstoPlayList(
        url: url,
        coverUrl: coverUrl,
        song: song,
        sharedSongRepo: sharedSongRepo);
  }
}
