import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marshal/application/dependency_injection.dart';
import 'package:marshal/data/models/song_model.dart';
import 'package:marshal/domain/Usecases/usecases.dart';

part 'recent_songs_state.dart';

class RecentSongsCubit extends Cubit<RecentSongsState> {
  RecentSongsCubit() : super(RecentSongsInitial());
  void getRecentSongs({String lastSong = ''}) async {
    Option<List<Song>> result =
        await locator<GetRecentSongs>().call(lastSong: lastSong);
    result.fold(() {
      emit(RecentSongsInitial());
    }, (result) {
      log('got recent songs');
      emit(RecentSongLoaded(songs: result));
    });
  }
}
