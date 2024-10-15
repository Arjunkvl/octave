import 'dart:async';

import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:dartz/dartz.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:id3tag/id3tag.dart';
import 'package:marshal/Api/get_image_url.dart';
import 'package:marshal/Api/get_song_url.dart';
import 'package:marshal/data/models/song_model.dart';
import 'package:marshal/data/models/Song%20Details%20Model/song_details_model.dart';

import 'package:marshal/domain/repository/Audio%20Manage%20Repo/audio_manage_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioManageImpl implements AudioManageRepo {
  @override
  Future<Option<ID3Tag>> extractAudioMetadata(File audioFile) async {
    // final data = await File(audioFile.path).readAsBytes();
    final tags = ID3TagReader.path(audioFile.path);
    final ID3Tag metadata = await tags.readTag();
    if (metadata.title != null) {
      return some(metadata);
    }
    return none();
  }

  @override
  Future<Option<UploadTask>> uploadAudio(
      {required File audioFile,
      required String songId,
      required ID3Tag tag,
      required String fileHash}) async {
    final storageRef = FirebaseStorage.instance.ref();
    final contains = await FirebaseFirestore.instance
        .collection('songs')
        .where('fileHash', isEqualTo: fileHash)
        .get();
    if (contains.docs.isEmpty) {
      final uploadTask = storageRef
          .child("songs/$songId.mp3")
          .putFile(audioFile, SettableMetadata(contentType: 'audio/mpeg'));
      return some(uploadTask);
    }
    return none();
  }

  @override
  Future<void> uploadEssentials(
      {required String songId,
      required ID3Tag tag,
      required String fileHash}) async {
    final Reference storageRef = FirebaseStorage.instance.ref();
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final store = await SharedPreferences.getInstance();
    final Box<Song> box = await Hive.openBox('songsBox');
    String uid = store.get('uid').toString();

    //genre and realses year;
    final genre = tag.frameWithTypeAndName<TextInformation>('TCON');
    final realeseYear = tag.frameWithTypeAndName<TextInformation>('TYER');
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
    final Song songSkelton = Song(
      uploadedAt: DateTime.now(),
      artist: tag.artist ?? '',
      songId: songId,
      songUrl: await getSongUrl(songId),
      title: tag.title ?? '',
      coverUrl: await getCoverUrl(songId),
      fileHash: fileHash,
    );
    box.put(songSkelton.songId, songSkelton);
    await db.collection('songs').doc(songId).set(songSkelton.toMap());

    await db
        .collection('songs')
        .doc(songId)
        .collection('SongDetails')
        .doc(songId)
        .set(SongDetailsModel(
          album: tag.album ?? '',
          genre: genre == null ? '' : genre.value,
          playCount: 0,
          likeCount: 0,
          releaseYear: realeseYear == null ? '' : realeseYear.value,
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

  @override
  Future<Option<List<Song>>> getSongFromSongIds({required List songIds}) async {
    List<Song> songs = [];
    List<Future<QuerySnapshot<Map<String, dynamic>>>> futures = [];
    List idsToFetch = [];
    List result = [];
    final Box<Song> box = await Hive.openBox('songsBox');
    for (var id in songIds) {
      Song? chacheSong = box.get(id);
      if (chacheSong != null) {
        songs.add(chacheSong);
      } else {
        idsToFetch.add(id);
      }
    }
    if (idsToFetch.isNotEmpty) {
      for (int i = 0; i < songIds.length; i += 10) {
        final List bacthedId = songIds.sublist(
            i, i + 10 > songIds.length ? songIds.length : i + 10);

        futures.add(FirebaseFirestore.instance
            .collection('songs')
            .where(FieldPath.documentId, whereIn: bacthedId)
            .get());
      }
      result = await Future.wait(futures);
      for (QuerySnapshot<Map<String, dynamic>> querySnapshot in result) {
        List<Song> newSongs = querySnapshot.docs
            .map((song) => Song.fromDocument(song.data()))
            .toList();
        for (Song s in newSongs) {
          box.put(s.songId, s);
        }
        songs.addAll(newSongs);
      }
    }

    return some(songs);
  }

  @override
  Future<String> generateFileHash({required File file}) async {
    final Uint8List bytes = await file.readAsBytes();
    final Digest digest = md5.convert(bytes);
    return digest.toString();
  }
}
