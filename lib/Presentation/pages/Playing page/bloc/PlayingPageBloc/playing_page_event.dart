part of 'playing_page_bloc.dart';

abstract class PlayingPageEvent extends Equatable {
  const PlayingPageEvent();

  @override
  List<Object> get props => [];
}

class LoadSongEvent extends PlayingPageEvent {
  final int index;
  final Song song;

  LoadSongEvent({required this.index, required this.song});
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
  final int index;

  SkipNextEvent({required this.index});

  @override
  List<Object> get props => [];
}

class SkipPreviousEvent extends PlayingPageEvent {
  final int index;

  SkipPreviousEvent({required this.index});

  @override
  List<Object> get props => [];
}

class UpdatePlayerBarEvent extends PlayingPageEvent {
  final Duration progress;

  UpdatePlayerBarEvent({required this.progress});
  @override
  List<Object> get props => [progress];
}
