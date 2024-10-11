import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marshal/data/models/song_model.dart';

part 'playing_page_components_state.dart';

class PlayingPageComponentsCubit extends Cubit<PlayingPageComponentsState> {
  PlayingPageComponentsCubit() : super(PlayingPageComponentsInitial());
  void setComponents({required Song song}) {
    log(song.toString());
    emit(SongComponentsState(song: song));
  }
}
