import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:marshal/data/models/PlayList%20Model/playlist_model.dart';

part 'add_to_play_list_state.dart';

class AddToPlayListCubit extends Cubit<AddToPlayListState> {
  AddToPlayListCubit() : super(AddToPlayListInitial());
  void addToPlayList() async {
    final Box<Playlist> box = await Hive.openBox('playListBox');
    emit(AddToPlayListInitial());
    emit(ShowChoosePlayListPage(playlist: box.values.toList()));
  }
}
