import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marshal/Presentation/pages/Home%20Page/helpers/variables.dart';
import 'package:marshal/application/dependency_injection.dart';
import 'package:marshal/data/models/song_model.dart';
import 'package:marshal/domain/Usecases/usecases.dart';

part 'all_songs_state.dart';

class AllSongsCubit extends Cubit<AllSongsState> {
  AllSongsCubit() : super(AllSongsInitial(songs: []));
  Future<void> getAllSongs({int page = 1}) async {
    final Option<List<Song>> result =
        await locator<GetAllSongsWithPagination>().call(page: page);
    result.fold(() {
      emit(NoSongFoundState(songs: []));
    }, (songs) {
      emit(AllSongsLoaded(songs: List.from(state.songs)..addAll(songs)));
      isfetching = false;
    });
  }
}
