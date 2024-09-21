// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'song_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SongAdapter extends TypeAdapter<Song> {
  @override
  final int typeId = 0;

  @override
  Song read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Song(
      author: fields[0] as String,
      coverId: fields[1] as String,
      songId: fields[2] as String,
      ext: fields[3] as String,
      name: fields[4] as String,
      coverUrl: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Song obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.author)
      ..writeByte(1)
      ..write(obj.coverId)
      ..writeByte(2)
      ..write(obj.songId)
      ..writeByte(3)
      ..write(obj.ext)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.coverUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
