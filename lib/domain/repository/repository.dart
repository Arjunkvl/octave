import 'package:dartz/dartz.dart';
import 'package:marshal/data/models/Category%20model/category_model.dart';
import 'package:marshal/data/models/song_model.dart';

abstract class SongRepo {
  Future<Option<List<Category>>> getCategories({String lastSong = ''});
  Future<Option<List<Song>>> getAllSongsWithPagination({required int page});
}
