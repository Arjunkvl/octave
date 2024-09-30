import 'package:firebase_storage/firebase_storage.dart';

Future<String> getSongUrl(String songId) async {
  final storageRef = FirebaseStorage.instance.ref();
  return await storageRef.child('songs').child('$songId.mp3').getDownloadURL();
}
