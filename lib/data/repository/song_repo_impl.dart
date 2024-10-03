import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:marshal/Presentation/pages/Home%20Page/helpers/variables.dart';
import 'package:marshal/data/models/song_model.dart';
import 'package:marshal/domain/repository/repository.dart';
import 'package:marshal/domain/repository/shared_song_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SongRepoImpl implements SongRepo {
  @override
  Future<Option<List<Song>>> getNewReleseas({String lastSong = ''}) async {
    final db = FirebaseFirestore.instance;
    Box<Song> dbNewrealeselist = await Hive.openBox<Song>('newReleaseList');
    // await dbNewrealeselist.clear();
    final query =
        db.collection('songs').orderBy('songId', descending: true).limit(5);

    lastFecthedId = lastSong;
    if (dbNewrealeselist.isNotEmpty) {
      log(lastSong);
      if (lastSong == '' && lastFecthedId == '') {
        return some(dbNewrealeselist.values
            .toList()
            .getRange(
                0,
                dbNewrealeselist.values.length < 5
                    ? dbNewrealeselist.values.length
                    : 5)
            .toList());
      } else {
        final List<Song> list = dbNewrealeselist.values.toList();
        final int index = list.indexWhere((song) => song.songId == lastSong);
        final int lenght = dbNewrealeselist.values.length;
        log(lenght.toString());
        final int remaining = lenght - (index + 1);
        final bool hasMore = remaining >= 1;

        if (hasMore) {
          return some(dbNewrealeselist.values
              .toList()
              .getRange(
                  index + 1, remaining >= 5 ? index + 6 : index + remaining + 1)
              .toList());
        } else {
          log(lastSong);
          final querySongs = await query.startAfter([lastSong]).get();
          List<Song> songs = querySongs.docs
              .map((song) => Song.fromDocument(song.data()))
              .toList();
          await dbNewrealeselist.addAll(songs);
          log('just after adding${dbNewrealeselist.values.length}');
          await dbNewrealeselist.close();
          return some(songs);
        }
      }
    } else {
      final querySongs = await query.get();
      log(querySongs.docs.length.toString());
      List<Song> songs = querySongs.docs
          .map((song) => Song.fromDocument(song.data()))
          .toList();
      await dbNewrealeselist.addAll(songs);
      await dbNewrealeselist.close();
      return some(songs);
    }
  }

  @override
  AudioSource addSongstoPlayList(
      {required String url,
      required String coverUrl,
      required Song song,
      required SharedSongRepo sharedSongRepo}) {
    sharedSongRepo.currentlyPlayingSongList.add(song);

    AudioSource sourceses = LockCachingAudioSource(
      Uri.parse(url),
      tag: MediaItem(
        id: '0',
        title: song.title,
        artUri: Uri.parse(song.coverUrl),
      ),
    );

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
}
