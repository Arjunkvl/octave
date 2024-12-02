import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:marshal/data/models/PlayList%20Model/playlist_model.dart';
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
  }

  void showAddToPlayList() async {
    final Box<Playlist> box = await Hive.openBox('playListBox');
    emit(AddToPlayList(playlist: box.values.toList()));
  }
}
