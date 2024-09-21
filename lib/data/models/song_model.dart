// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';

part 'song_model.g.dart';

@HiveType(typeId: 0)
class Song extends Equatable {
  @HiveField(0)
  final String author;
  @HiveField(1)
  final String coverId;
  @HiveField(2)
  final String songId;
  @HiveField(3)
  final String ext;
  @HiveField(4)
  final String name;
  @HiveField(5)
  final String coverUrl;
  Song(
      {required this.author,
      required this.coverId,
      required this.songId,
      required this.ext,
      required this.name,
      this.coverUrl = ''});

  Song copyWith({
    String? author,
    String? coverId,
    String? songId,
    String? ext,
    String? name,
    String? coverUrl,
  }) {
    return Song(
      author: author ?? this.author,
      coverId: coverId ?? this.coverId,
      songId: songId ?? this.songId,
      ext: ext ?? this.ext,
      name: name ?? this.name,
      coverUrl: coverUrl ?? this.coverUrl,
    );
  }

  // Factory constructor to create a Song instance from a document
  factory Song.fromDocument(Map<String, dynamic> doc) {
    return Song(
      author: doc['author'] ?? '', // Provide default value if key is missing
      coverId: doc['coverId'] ?? '',
      songId: doc['songId'] ?? '',
      ext: doc['ext'] ?? '',
      name: doc['name'] ?? '',
      coverUrl:
          doc['coverUrl'] ?? '', // Provide default value if key is missing
    );
  }
  @override
  List<Object?> get props => [author, coverId, songId, ext, name, coverUrl];

  Map<String, dynamic> toMap() {
    return {
      'author': author,
      'coverId': coverId,
      'songId': songId,
      'ext': ext,
      'name': name,
      'coverUrl': coverId,
    };
  }

  static Song fromMap(Map<String, dynamic> map) {
    return Song(
        author: map['author'],
        coverId: map['coverId'],
        songId: map['songId'],
        ext: map['ext'],
        name: map['name']);
  }
}
