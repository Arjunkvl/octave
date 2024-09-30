// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';

part 'song_model.g.dart';

@HiveType(typeId: 0)
class Song extends Equatable {
  @HiveField(0)
  final String author;
  @HiveField(1)
  final String songId;
  @HiveField(2)
  final String songUrl;
  @HiveField(3)
  final String name;
  @HiveField(4)
  final String coverUrl;
  @HiveField(5)
  final DateTime createdAt;
  Song(
      {required this.createdAt,
      required this.author,
      required this.songId,
      required this.songUrl,
      required this.name,
      required this.coverUrl});

  Song copyWith({
    String? author,
    String? coverId,
    String? songId,
    String? songUrl,
    String? name,
    String? coverUrl,
    DateTime? createdAt,
  }) {
    return Song(
      author: author ?? this.author,
      songId: songId ?? this.songId,
      songUrl: songUrl ?? this.songUrl,
      name: name ?? this.name,
      coverUrl: coverUrl ?? this.coverUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Factory constructor to create a Song instance from a document
  factory Song.fromDocument(Map<String, dynamic> doc) {
    return Song(
      author: doc['author'] ?? '', // Provide default value if key is missing

      songId: doc['songId'] ?? '',
      songUrl: doc['songUrl'] ?? '',
      name: doc['name'] ?? '',
      coverUrl: doc['coverUrl'] ?? '',
      createdAt: doc['createdAt'].toDate() ??
          '', // Provide default value if key is missing
    );
  }
  @override
  List<Object?> get props =>
      [author, songId, songUrl, name, coverUrl, createdAt];

  Map<String, dynamic> toMap() {
    return {
      'author': author,
      'songId': songId,
      'songUrl': songUrl,
      'coverUrl': coverUrl,
      'name': name,
      'createdAt': createdAt,
    };
  }

  static Song fromMap(Map<String, dynamic> map) {
    return Song(
        author: map['author'],
        songId: map['songId'],
        songUrl: map['songUrl'],
        name: map['name'],
        coverUrl: map['coverUrl'],
        createdAt: map['createdAt']);
  }
}
