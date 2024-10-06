// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_source_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AudioSourceModelAdapter extends TypeAdapter<AudioSourceModel> {
  @override
  final int typeId = 1;

  @override
  AudioSourceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AudioSourceModel(
      songs: (fields[1] as List).cast<Song>(),
      audioSources: (fields[0] as List).cast<AudioSource>(),
    );
  }

  @override
  void write(BinaryWriter writer, AudioSourceModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.audioSources)
      ..writeByte(1)
      ..write(obj.songs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioSourceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
