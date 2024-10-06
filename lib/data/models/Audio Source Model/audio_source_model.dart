import 'package:hive_flutter/adapters.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marshal/data/models/song_model.dart';

part 'audio_source_model.g.dart';

@HiveType(typeId: 1)
class AudioSourceModel {
  @HiveField(0)
  final List<AudioSource> audioSources;
  @HiveField(1)
  final List<Song> songs;
  AudioSourceModel({required this.songs, required this.audioSources});
}
