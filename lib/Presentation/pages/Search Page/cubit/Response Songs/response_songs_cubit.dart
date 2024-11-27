import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marshal/application/Services/Spotify/spotify_api.dart';
import 'package:marshal/data/models/song_model.dart';

part 'response_songs_state.dart';

class ResponseSongsCubit extends Cubit<ResponseSongsState> {
  ResponseSongsCubit() : super(ResponseSongsInitial());
  Future<void> trySearching({required String query}) async {
    if (query == '') return;
    final List<Song> result = await SpotifyService().search(query: query);
    emit(ShowResultState(listOfSongs: result));
  }
}
