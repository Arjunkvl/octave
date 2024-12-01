import 'package:hive_flutter/adapters.dart';
import 'package:marshal/Api/SpotifyApiModel/api_model.dart';
import 'package:marshal/data/models/PlayList%20Model/playlist_model.dart';
import 'package:marshal/data/models/song_model.dart';

Future<void> hiveStartUp() async {
  await Hive.initFlutter();
  Hive.registerAdapter(SongAdapter());
  Hive.registerAdapter(SpotifyApiModelAdapter());
  Hive.registerAdapter(PlaylistAdapter());
}
