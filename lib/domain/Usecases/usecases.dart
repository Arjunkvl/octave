import 'package:dartz/dartz.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marshal/data/models/Category%20model/category_model.dart';
import 'package:marshal/data/models/song_model.dart';
import 'package:marshal/data/repository/song_repo_impl.dart';
import 'package:marshal/domain/repository/shared_song_repo.dart';

class GetCategories {
  final SongRepoImpl repository;

  GetCategories({required this.repository});
  Future<Option<List<Category>>> call({String lastSong = ''}) async {
    return await repository.getCategories(lastSong: lastSong);
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
  Future<List<AudioSource>> call(
      {required List<Song> songs,
      required SharedSongRepo sharedSongRepo}) async {
    return await repository.addSongstoPlayList(
        songs: songs, sharedSongRepo: sharedSongRepo);
  }
}

class GetAllSongsWithPagination {
  final SongRepoImpl repository;

  GetAllSongsWithPagination({required this.repository});
  Future<Option<List<Song>>> call({required int page}) async {
    return await repository.getAllSongsWithPagination(page: page);
  }
}
