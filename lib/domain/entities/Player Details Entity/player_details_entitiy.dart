// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'player_details_entitiy.g.dart';

@JsonSerializable()
class PlayerDetailsEntitiy {
  final Duration totalDuration;
  final Duration progress;

  PlayerDetailsEntitiy({
    required this.totalDuration,
    required this.progress,
  });

  factory PlayerDetailsEntitiy.fromJson(Map<String, dynamic> json) =>
      _$PlayerDetailsEntitiyFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerDetailsEntitiyToJson(this);
}
