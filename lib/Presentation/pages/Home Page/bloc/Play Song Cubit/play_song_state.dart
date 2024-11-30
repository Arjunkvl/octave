part of 'play_song_cubit.dart';

sealed class PlaySongState extends Equatable {
  const PlaySongState();

  @override
  List<Object> get props => [];
}

final class PlaySongInitial extends PlaySongState {}

final class ShowSongPage extends PlaySongState {
  final Song song;

  const ShowSongPage({required this.song});
}
