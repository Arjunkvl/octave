part of 'playing_page_bloc.dart';

abstract class PlayingPageEvent extends Equatable {
  const PlayingPageEvent();

  @override
  List<Object> get props => [];
}

class AddSongsEvent extends PlayingPageEvent {}

class LoadSongEvent extends PlayingPageEvent {
  final Song song;

  LoadSongEvent({required this.song});
  @override
  List<Object> get props => [song];
}

class PauseSongEvent extends PlayingPageEvent {
  @override
  List<Object> get props => [];
}

class PlaySongEvent extends PlayingPageEvent {
  @override
  List<Object> get props => [];
}

class SkipNextEvent extends PlayingPageEvent {
  @override
  List<Object> get props => [];
}

class SkipPreviousEvent extends PlayingPageEvent {
  @override
  List<Object> get props => [];
}

class UpdatePlayerBarEvent extends PlayingPageEvent {
  final Duration progress;

  UpdatePlayerBarEvent({required this.progress});
  @override
  List<Object> get props => [progress];
}

class SeekEvent extends PlayingPageEvent {
  final Duration progress;

  SeekEvent({required this.progress});
  @override
  List<Object> get props => [progress];
}
