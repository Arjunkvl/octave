import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marshal/application/dependency_injection.dart';
import 'package:marshal/data/models/PlayList%20Model/playlist_model.dart';
import 'package:marshal/domain/Usecases/User%20SetUp%20Usecases/user_setup_usecases.dart';

part 'library_event.dart';
part 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  LibraryBloc() : super(LibraryLoading()) {
    on<GetPlayListsEvent>((event, emit) async {
      List<Playlist> playLists = await locator<GetPlayLists>().call();
      emit(LibraryLoaded(playLists: List.from(playLists)));
    });
    on<AddPlayListEvent>((event, emit) {
      locator<AddPlayListToCloud>().call(playList: event.playlist);
    });
    on<RemovePlayListEvent>((event, emit) async {
      await locator<RemovePlayListFromCloud>().call(title: event.title);
    });
  }
}
