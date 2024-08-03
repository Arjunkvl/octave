// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_details_entitiy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerDetailsEntitiy _$PlayerDetailsEntitiyFromJson(
        Map<String, dynamic> json) =>
    PlayerDetailsEntitiy(
      totalDuration:
          Duration(microseconds: (json['totalDuration'] as num).toInt()),
      progress: Duration(microseconds: (json['progress'] as num).toInt()),
    );

Map<String, dynamic> _$PlayerDetailsEntitiyToJson(
        PlayerDetailsEntitiy instance) =>
    <String, dynamic>{
      'totalDuration': instance.totalDuration.inMicroseconds,
      'progress': instance.progress.inMicroseconds,
    };
