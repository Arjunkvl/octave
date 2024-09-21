import 'dart:io';

import 'package:audiotags/audiotags.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
      {required File audioFile, required songId, required Tag tag}) async {
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
    String uid = store.get('uid').toString();
    await db.collection('users').doc(uid).collection('song').doc(uid).update(
      {
        'uploaded_songs': FieldValue.arrayUnion([songId])
      },
    ).then((e) async {
      await db.collection('songs').doc().set(
            Song(
                    author: tag.trackArtist!,
                    coverId: '$songId.webp',
                    songId: songId,
                    ext: 'mp3',
                    name: tag.title!)
                .toMap(),
          );
    });
    storageRef.child('covers/$songId.webp').putData(
          tag.pictures[0].bytes,
          SettableMetadata(
              contentType: 'image/webp', customMetadata: {'uid': uid}),
        );
  }
}
