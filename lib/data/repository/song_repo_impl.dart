import 'package:audio_service/audio_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:marshal/data/helping_var.dart';
import 'package:marshal/data/models/Category%20model/category_model.dart';
import 'package:marshal/data/models/song_model.dart';
import 'package:marshal/domain/repository/repository.dart';
import 'package:marshal/domain/repository/shared_song_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Future<List<AudioSource>> addSongstoPlayList(
      {required List<Song> songs,
      required SharedSongRepo sharedSongRepo}) async {
    // sharedSongRepo.currentlyPlayingSongList.addAll(songs);
    sharedSongRepo.currentlyPlayingSongList.addAll(songs);
    List<AudioSource> sourceses = List.generate(
        songs.length,
        (index) => LockCachingAudioSource(
              Uri.parse(songs[index].songUrl),
              tag: MediaItem(
                playable: false,
                id: '0',
                title: songs[index].title,
                artUri: Uri.parse(songs[index].coverUrl),
              ),
            ));

    return sourceses;
  }

  @override
  Future<Option<List<Song>>> getRecentSongs({String lastSong = ''}) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final SharedPreferences store = await SharedPreferences.getInstance();
    final String? uid = store.getString('uid');
    Box<Song> dbRecentSongsList = await Hive.openBox<Song>('recentSongs');
    CollectionReference<Map<String, dynamic>> query = db
        .collection('users')
        .doc(uid)
        .collection('songs')
        .doc(uid)
        .collection('recentSongs');
    if (dbRecentSongsList.isNotEmpty) {
      if (lastSong == '') {
        return some(dbRecentSongsList.values
            .toList()
            .getRange(
                0,
                dbRecentSongsList.values.length < 5
                    ? dbRecentSongsList.values.length
                    : 5)
            .toList());
      } else {
        final int index = dbRecentSongsList.values
            .toList()
            .indexWhere((song) => song.songId == lastSong);
        final int length = dbRecentSongsList.values.length;
        final bool hasMore = length - (index + 1) >= 1;
        if (hasMore) {
          return some(dbRecentSongsList.values
              .toList()
              .getRange(index + 1, length >= 5 ? index + 6 : index + length + 1)
              .toList());
        } else {
          final songQuery = await query.startAfter([lastSong]).get();
          List<Song> songs = songQuery.docs
              .map((song) => Song.fromDocument(song.data()))
              .toList();

          return some(songs);
        }
      }
    } else {
      final querySongs =
          await query.orderBy('createdAt', descending: true).limit(10).get();
      List<Song> songs = querySongs.docs
          .map((song) => Song.fromDocument(song.data()))
          .toList();

      return some(songs);
    }
  }

  @override
  Future<Option<List<Song>>> getAllSongsWithPagination() async {
    final db = FirebaseFirestore.instance;
    final query =
        db.collection('songs').orderBy('uploadedAt', descending: true).limit(9);
    if (lastDoc == null) {
      final result = await query.get();
      songs.addAll(result.docs.map((song) => Song.fromDocument(song.data())));
      lastDoc = result.docs.last;
    } else {
      final result = await query.startAfterDocument(lastDoc!).get();
      if (result.docs.isNotEmpty) {
        songs.addAll(result.docs.map((song) => Song.fromDocument(song.data())));
        lastDoc = result.docs.last;
      }
    }
    return some(songs);
  }
}
