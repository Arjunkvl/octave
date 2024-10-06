import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:marshal/data/models/song_model.dart';

part 'top_tile_state.dart';

class TopTileCubit extends Cubit<TopTileState> {
  TopTileCubit() : super(TopTileInitial());
  Future<void> getSongsForTile() async {
    final Box<Song> box = await Hive.openBox('songsBox');
    final int length = box.values.length;
    if (length >= 6) {
      emit(TopTileLoading());
      final List<Song> songs = box.values.toList().sublist(length - 6, length);
      emit(TopTileLoaded(songs: songs));
    }
  }
}
