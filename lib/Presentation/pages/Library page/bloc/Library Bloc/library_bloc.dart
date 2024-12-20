import 'package:audio_service/audio_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marshal/Presentation/pages/Library%20page/helpers/variables.dart';
import 'package:marshal/Presentation/pages/Playing%20page/helpers/variables.dart';
import 'package:marshal/application/Services/audio_handler.dart';
import 'package:marshal/application/dependency_injection.dart';
import 'package:marshal/core/recently_playing_list.dart';
import 'package:marshal/data/models/PlayList%20Model/playlist_model.dart';
import 'package:marshal/data/models/song_model.dart';
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
    on<RemoveFromPlayListEvent>((event, emit) async {
      List<Song> newSongList = event.playlist.songs;
      newSongList.removeAt(event.index);
      await locator<UpdatePlayList>()
          .call(playList: event.playlist.copyWith(songs: newSongList));
      return;
    });
    on<AddToPlayListEvent>((event, emit) async {
      List<Song> newSongList = event.playlist.songs;
      if (!event.playlist.songs.contains(event.song)) {
        newSongList.add(event.song);
        await locator<UpdatePlayList>()
            .call(playList: event.playlist.copyWith(songs: newSongList));
      }
      return;
    });
    on<PlayListToQueue>((event, emit) async {
      final CustmAudioHandler audioHandler =
          locator<AudioHandler>() as CustmAudioHandler;
      playingSongList = [];
      index = -1;
      await audioHandler.startFreshQueue();
      queueOfSongs = event.playlist.songs;
    });
  }
}
