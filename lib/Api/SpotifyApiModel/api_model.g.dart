// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SpotifyApiModelAdapter extends TypeAdapter<SpotifyApiModel> {
  @override
  final int typeId = 1;

  @override
  SpotifyApiModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SpotifyApiModel(
      api: fields[0] as String,
      expairesAt: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SpotifyApiModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.api)
      ..writeByte(1)
      ..write(obj.expairesAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpotifyApiModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
