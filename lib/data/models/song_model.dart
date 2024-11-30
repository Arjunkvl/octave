// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';

part 'song_model.g.dart';

@HiveType(typeId: 0)
class Song extends Equatable {
  @HiveField(0)
  final String artist;
  @HiveField(1)
  final String songId;
  @HiveField(2)
  final String songUrl;
  @HiveField(3)
  final String title;
  @HiveField(4)
  final String coverUrl;
  @HiveField(5)
  final DateTime uploadedAt;
  @HiveField(6)
  final String fileHash;
  const Song(
      {required this.uploadedAt,
      required this.artist,
      required this.songId,
      required this.songUrl,
      required this.title,
      required this.coverUrl,
      required this.fileHash});

  Song copyWith({
    String? artist,
    String? coverId,
    String? songId,
    String? songUrl,
    String? title,
    String? coverUrl,
    DateTime? uploadedAt,
    String? fileHash,
  }) {
    return Song(
      artist: artist ?? this.artist,
      songId: songId ?? this.songId,
      songUrl: songUrl ?? this.songUrl,
      title: title ?? this.title,
      coverUrl: coverUrl ?? this.coverUrl,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      fileHash: fileHash ?? this.fileHash,
    );
  }

  // Factory constructor to create a Song instance from a document
  factory Song.fromDocument(Map<String, dynamic> doc) {
    return Song(
      artist: doc['artist'] ?? '', // Provide default value if key is missing
      songId: doc['songId'] ?? '',
      songUrl: doc['songUrl'] ?? '',
      title: doc['title'] ?? '',
      coverUrl: doc['coverUrl'] ?? '',
      uploadedAt: doc['uploadedAt'].toDate() ?? '',
      fileHash: doc['fileHash'], // Provide default value if key is missing
    );
  }
  @override
  List<Object?> get props =>
      [artist, songId, songUrl, title, coverUrl, uploadedAt, fileHash];

  Map<String, dynamic> toMap() {
    return {
      'artist': artist,
      'songId': songId,
      'songUrl': songUrl,
      'coverUrl': coverUrl,
      'title': title,
      'uploadedAt': uploadedAt,
      'fileHash': fileHash,
    };
  }

  static Song fromMap(Map<String, dynamic> map) {
    return Song(
        artist: map['author'],
        songId: map['songId'],
        songUrl: map['songUrl'],
        title: map['title'],
        coverUrl: map['coverUrl'],
        uploadedAt: map['uploadedAt'],
        fileHash: map['fileHash']);
  }
}
