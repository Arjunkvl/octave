import 'package:firebase_storage/firebase_storage.dart';

Future<String> getCoverUrl(String coverId) async {
  final storage = FirebaseStorage.instance.ref();
  final covers = storage.child('covers');
  final image = covers.child(coverId);
  final String url = await image.getDownloadURL();
  return url;
}
