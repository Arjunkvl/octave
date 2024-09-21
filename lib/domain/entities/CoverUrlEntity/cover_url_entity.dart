import 'package:hive_flutter/adapters.dart';
import 'package:marshal/data/models/song_model.dart';

part 'cover_url_entity.g.dart';

@HiveType(typeId: 1)
class CoverUrlEntity {
  @HiveField(0)
  final Song song;
  @HiveField(1)
  final String coverUrl;

  CoverUrlEntity({required this.song, required this.coverUrl});
}
