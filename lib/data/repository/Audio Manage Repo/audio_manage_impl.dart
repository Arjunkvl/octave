import 'dart:async';
import 'dart:io';

import 'package:audiotags/audiotags.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:marshal/Api/get_image_url.dart';
import 'package:marshal/Api/get_song_url.dart';
import 'package:marshal/data/models/song_model.dart';

import 'package:marshal/domain/repository/Audio%20Manage%20Repo/audio_manage_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioManageImpl implements AudioManageRepo {
  @override
  Future<Option<Tag>> extractAudioMetadata(File audioFile) async {
    Tag? tag = await AudioTags.read(audioFile.path);
    if (tag != null) {
      return Some(tag);
    } else {
      return none();
    }
  }

  @override
  Future<UploadTask> uploadAudio(
      {required File audioFile,
      required String songId,
      required Tag tag}) async {
    final storageRef = FirebaseStorage.instance.ref();
    final uploadTask = storageRef
        .child("songs/$songId.mp3")
        .putFile(audioFile, SettableMetadata(contentType: 'audio/mpeg'));
    return uploadTask;
  }

  @override
  Future<void> uploadEssentials(
      {required String songId, required Tag tag}) async {
    final Reference storageRef = FirebaseStorage.instance.ref();
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final store = await SharedPreferences.getInstance();
    final FieldValue timestamp = FieldValue.serverTimestamp();
    String uid = store.get('uid').toString();
    await storageRef
        .child('covers/$songId.webp')
        .putData(tag.pictures[0].bytes)
        .whenComplete((() async {
      await db
          .collection('users')
          .doc(uid)
          .collection('songs')
          .doc(uid)
          .collection('uploadedSongs')
          .doc()
          .set(Song(
            createdAt: DateTime.now(),
            author: tag.trackArtist ?? '',
            songId: songId,
            songUrl: await getSongUrl(songId),
            name: tag.title ?? '',
            coverUrl: await getCoverUrl(songId),
          ).toMap());
    }));
    await db.collection('songs').doc().set(Song(
          createdAt: DateTime.now(),
          author: tag.trackArtist ?? '',
          songId: songId,
          songUrl: await getSongUrl(songId),
          name: tag.title ?? '',
          coverUrl: await getCoverUrl(songId),
        ).toMap());
  }

  @override
  Future<void> uploadToRecentSongs({required Song song}) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final store = await SharedPreferences.getInstance();
    String uid = store.get('uid').toString();
    await db
        .collection('users')
        .doc(uid)
        .collection('songs')
        .doc(uid)
        .collection('recentSongs')
        .doc()
        .set(Song(
          createdAt: song.createdAt,
          author: song.author,
          songId: song.songId,
          songUrl: song.songUrl,
          name: song.name,
          coverUrl: song.coverUrl,
        ).toMap());
  }
}
