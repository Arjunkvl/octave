import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:marshal/data/models/song_model.dart';

part 'playlist_model.g.dart';

@HiveType(typeId: 2)
class Playlist extends Equatable {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String cover;
  @HiveField(2)
  final List<Song> songs;

  const Playlist(
      {required this.title, required this.cover, required this.songs});
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'cover': cover,
      'songs': songs.map((song) => song.toMap()).toList(),
    };
  }

  Playlist copyWith({
    String? title,
    String? cover,
    List<Song>? songs,
  }) {
    return Playlist(
        title: title ?? this.title,
        cover: cover ?? this.cover,
        songs: songs ?? this.songs);
  }

  factory Playlist.fromDocument(Map<String, dynamic> doc) {
    List<Song> list = [];
    for (var song in doc['songs']) {
      list.add(Song.fromDocument(song));
    }
    return Playlist(
        title: doc['title'] ?? '', cover: doc['cover'] ?? '', songs: list);
  }

  @override
  List<Object?> get props => [songs, title, cover];
}
