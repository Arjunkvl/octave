import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marshal/Presentation/pages/Home%20Page/helpers/variables.dart';
import 'package:marshal/application/dependency_injection.dart';
import 'package:marshal/data/models/song_model.dart';
import 'package:marshal/domain/Usecases/usecases.dart';

part 'all_songs_state.dart';

class AllSongsCubit extends Cubit<AllSongsState> {
  AllSongsCubit() : super(AllSongsInitial());
  Future<void> getAllSongs() async {
    log('triggered');
    final Option<List<Song>> result =
        await locator<GetAllSongsWithPagination>().call();
    result.fold(() {}, (songs) {
      emit(AllSongsLoaded(songs: List.from(songs)));
      isfetching = false;
    });
  }
}
