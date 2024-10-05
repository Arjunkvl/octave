import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:marshal/data/models/song_model.dart';

part 'top_tile_state.dart';

class TopTileCubit extends Cubit<TopTileState> {
  TopTileCubit() : super(TopTileInitial());
  Future<void> getSongsForTile() async {
    final Box<Song> box = await Hive.openBox('songsBox');
    if (box.values.length >= 6) {
      emit(TopTileLoading());
      final List<Song> songs = box.values.take(6).toList();
      emit(TopTileLoaded(songs: songs));
    }
  }
}
