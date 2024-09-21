import 'package:firebase_storage/firebase_storage.dart';

Future<String> getSongUrl(String songId) async {
  final storage = FirebaseStorage.instance.ref();
  final covers = storage.child('songs');
  final song = covers.child(songId);
  final String url = await song.getDownloadURL();
  return url;
}
