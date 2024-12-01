import 'package:dartz/dartz.dart';
import 'package:marshal/data/models/Category%20model/category_model.dart';
import 'package:marshal/data/models/song_model.dart';
import 'package:marshal/data/repository/song_repo_impl.dart';

class GetCategories {
  final SongRepoImpl repository;

  GetCategories({required this.repository});
  Future<Option<List<Category>>> call({String lastSong = ''}) async {
    return await repository.getCategories(lastSong: lastSong);
  }
}

class GetAllSongsWithPagination {
  final SongRepoImpl repository;

  GetAllSongsWithPagination({required this.repository});
  Future<Option<List<Song>>> call({required int page}) async {
    return await repository.getAllSongsWithPagination(page: page);
  }
}
