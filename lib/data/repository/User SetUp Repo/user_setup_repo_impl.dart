import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:marshal/data/models/PlayList%20Model/playlist_model.dart';
import 'package:marshal/domain/repository/User%20SetUp%20Repo/user_setUp_repo.dart';

class UserSetupRepoImpl implements UserSetupRepo {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  @override
  Future<void> setCloudSpace() async {
    final data = await db
        .collection('users')
        .doc(uid)
        .collection('playLists')
        .doc('likedList')
        .get();

    if (!data.exists) {
      await db
          .collection('users')
          .doc(uid)
          .collection('playLists')
          .doc('likedList')
          .set({'title': 'Liked Songs', 'cover': '', 'songs': []});
    }
  }

  @override
  Future<void> addPlayList({required Playlist playList}) async {
    await db
        .collection('users')
        .doc(uid)
        .collection('playLists')
        .doc(playList.title)
        .set(playList.toMap());
    log('reached');
  }

  @override
  Future<List<Playlist>> getPlayLists() async {
    final Box<Playlist> box = await Hive.openBox('playListBox');
    List<Playlist> playlists = [];
    final response =
        await db.collection('users').doc(uid).collection('playLists').get();
    for (var i in response.docs) {
      playlists.add(Playlist.fromDocument(i.data()));
    }
    await box.clear();
    await box.addAll(playlists);
    return playlists.reversed.toList();
  }

  @override
  Future<void> removePlayList({required String title}) async {
    final Box<Playlist> box = await Hive.openBox('playListBox');
    final int index =
        box.values.toList().indexWhere((playlist) => playlist.title == title);
    log(box.values.length.toString());
    await box.deleteAt(index);
    log(box.values.length.toString());
    await db
        .collection('users')
        .doc(uid)
        .collection('playLists')
        .doc(title)
        .delete();
    log('deleted');
  }

  @override
  Future<void> updatePlayList({required Playlist playList}) async {
    final Box<Playlist> box = await Hive.openBox('playListBox');
    final int index = box.values
        .toList()
        .indexWhere((playlist) => playlist.title == playList.title);
    box.putAt(index, playList);
    await db
        .collection('users')
        .doc(uid)
        .collection('playLists')
        .doc(playList.title)
        .set(playList.toMap());
    log(box.getAt(index).toString());
  }
}
