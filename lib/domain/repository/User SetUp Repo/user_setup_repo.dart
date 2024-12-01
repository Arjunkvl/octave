import 'package:marshal/data/models/PlayList%20Model/playlist_model.dart';

abstract class UserSetupRepo {
  Future<void> setCloudSpace();
  Future<void> addPlayList({required Playlist playList});
  Future<void> removePlayList({required String title});
  Future<List<Playlist>> getPlayLists();
}
