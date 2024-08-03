import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Song extends Equatable {
  final String author;
  final String coverId;
  final String songId;
  final String ext;
  final String name;
  Song(
      {required this.author,
      required this.coverId,
      required this.songId,
      required this.ext,
      required this.name});

  factory Song.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Song(
      author: data['author'] ?? '',
      coverId: data['coverId'] ?? '',
      songId: data['songId'] ?? '',
      ext: data['ext'] ?? '',
      name: data['name'] ?? '',
    );
  }

  @override
  List<Object?> get props => [author, count, songId, ext, name];
}
