import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:id3tag/id3tag.dart';
import 'package:marshal/Api/get_image_url.dart';
import 'package:marshal/Api/get_song_url.dart';
import 'package:marshal/data/models/song_model.dart';
import 'package:marshal/data/models/upload%20song%20model/upload_song_model.dart';

import 'package:marshal/domain/repository/Audio%20Manage%20Repo/audio_manage_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioManageImpl implements AudioManageRepo {
  @override
  Future<Option<ID3Tag>> extractAudioMetadata(File audioFile) async {
    // final data = await File(audioFile.path).readAsBytes();
    final tags = ID3TagReader.path(audioFile.path);
    final ID3Tag metadata = await tags.readTag();
    return some(metadata);
  }

  @override
  Future<UploadTask> uploadAudio(
      {required File audioFile,
      required String songId,
      required ID3Tag tag}) async {
    final storageRef = FirebaseStorage.instance.ref();
    final uploadTask = storageRef
        .child("songs/$songId.mp3")
        .putFile(audioFile, SettableMetadata(contentType: 'audio/mpeg'));
    return uploadTask;
  }

  @override
  Future<void> uploadEssentials(
      {required String songId, required ID3Tag tag}) async {
    final Reference storageRef = FirebaseStorage.instance.ref();
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final store = await SharedPreferences.getInstance();
    String uid = store.get('uid').toString();
    await storageRef
        .child('covers/$songId.webp')
        .putData(
          Uint8List.fromList(tag.pictures.first.imageData),
        )
        .whenComplete((() async {
      await db.collection('users').doc(uid).collection('songs').doc(uid).set({
        'uploadedSongs': FieldValue.arrayUnion([songId])
      }, SetOptions(merge: true));
    }));
    await db.collection('songs').doc(songId).set(Song(
          uploadedAt: DateTime.now(),
          artist: tag.artist ?? '',
          songId: songId,
          songUrl: await getSongUrl(songId),
          title: tag.title ?? '',
          coverUrl: await getCoverUrl(songId),
        ).toMap());
    await db
        .collection('songs')
        .doc(songId)
        .collection('SongDetails')
        .doc(songId)
        .set(SongDetailsModel(
          album: tag.album ?? '',
          genre: tag.frameWithTypeAndName<TextInformation>('TCON')!.value,
          playCount: 0,
          likeCount: 0,
          releaseYear: tag.frameWithTypeAndName<TextInformation>('TYER')!.value,
          language: '',
        ).toMap());
  }

  @override
  Future<void> uploadToRecentSongs({required String songId}) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final store = await SharedPreferences.getInstance();
    String uid = store.get('uid').toString();

    await db.collection('users').doc(uid).collection('songs').doc(uid).set({
      'recentSongs': FieldValue.arrayUnion([songId])
    }, SetOptions(merge: true));
  }
}
