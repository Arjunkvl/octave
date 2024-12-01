import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marshal/data/models/song_model.dart';

part 'play_song_state.dart';

class PlaySongCubit extends Cubit<PlaySongState> {
  PlaySongCubit() : super(PlaySongInitial());
  void playSong({required Song song}) {
    emit(PlaySongInitial());
    emit(ShowSongPage(song: song));
  }

  void showPlayListAdd() {
    emit(PlaySongInitial());
    emit(PlayListEdit());
    log('fubction called');
  }
}
