import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marshal/application/dependency_injection.dart';
import 'package:marshal/data/models/song_model.dart';
import 'package:marshal/domain/Usecases/audio%20manage%20usecases/audio_usecases.dart';

part 'song_state.dart';

class SongCubit extends Cubit<SongState> {
  SongCubit() : super(SongLoading());
  List<Song> list = [];
  Future<void> fetchSongs({required List songIds}) async {
    if (list.isEmpty) {
      final result = await locator<GetSongFromSongIds>().call(songIds: songIds);
      result.fold(() {
        emit(SongError());
      }, (songs) {
        list = songs;
        emit(SongLoaded(songs: songs));
      });
    }
  }
}
