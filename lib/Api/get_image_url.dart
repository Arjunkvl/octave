import 'package:firebase_storage/firebase_storage.dart';

Future<String> getCoverUrl(String coverId) async {
  final storageRef = FirebaseStorage.instance.ref();
  return await storageRef
      .child('covers')
      .child('$coverId.webp')
      .getDownloadURL();
}
