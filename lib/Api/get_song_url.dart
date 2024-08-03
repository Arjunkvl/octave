import 'package:firebase_storage/firebase_storage.dart';

Future<String> getSongUrl(String coverId) async {
  final storage = FirebaseStorage.instance.ref();
  final covers = storage.child('songs');
  final song = covers.child(coverId);
  final String url = await song.getDownloadURL();
  return url;
}
