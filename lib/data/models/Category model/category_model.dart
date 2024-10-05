// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:marshal/data/models/song_model.dart';

class Category {
  final String name;
  final List songIds;
  final List<Song> songs;

  Category({required this.name, required this.songIds, this.songs = const []});
  static fromMap(Map<String, dynamic> map) async {
    return Category(name: map['name'], songIds: map['songIds']);
  }

  factory Category.fromDocument(Map<String, dynamic> doc) {
    return Category(name: doc['name'] ?? '', songIds: doc['songIds']);
  }

  Category copyWith({
    String? name,
    List<String>? songIds,
    List<Song>? songs,
  }) {
    return Category(
      name: name ?? this.name,
      songIds: songIds ?? this.songIds,
      songs: songs ?? this.songs,
    );
  }
}
