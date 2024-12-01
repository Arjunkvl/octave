import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:marshal/data/models/Category%20model/category_model.dart';
import 'package:marshal/data/models/song_model.dart';
import 'package:marshal/domain/repository/repository.dart';

class SongRepoImpl implements SongRepo {
  @override
  Future<Option<List<Category>>> getCategories({String lastSong = ''}) async {
    final categoryDocs = await FirebaseFirestore.instance
        .collection('categories')
        .orderBy('rank', descending: true)
        .get();
    final List<Category> categoryList = categoryDocs.docs.map((category) {
      return Category.fromDocument(category.data());
    }).toList();
    if (categoryList.isNotEmpty) {
      return some(categoryList);
    } else {
      return none();
    }
  }

  @override
  Future<Option<List<Song>>> getAllSongsWithPagination(
      {required int page}) async {
    final Box<Song> box = await Hive.openBox<Song>('tapsBox');
    int pageSize = 9;
    final int startIndex = page * pageSize;
    final int endIndex = startIndex + pageSize;
    final int length = box.length;
    if (startIndex > length) {
      return none();
    }
    final List<Song> songs = [];
    for (int i = startIndex; i < endIndex && i < length; i++) {
      songs.add(box.getAt((box.values.length - (i % box.values.length)) - 1)!);
    }
    if (songs.isNotEmpty) {
      return some(songs);
    } else {
      return none();
    }
  }
}
