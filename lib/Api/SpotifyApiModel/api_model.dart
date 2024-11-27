import 'package:hive_flutter/adapters.dart';

part 'api_model.g.dart';

@HiveType(typeId: 1)
class SpotifyApiModel {
  @HiveField(0)
  final String api;
  @HiveField(1)
  final DateTime expairesAt;
  SpotifyApiModel({required this.api, required this.expairesAt});
}
