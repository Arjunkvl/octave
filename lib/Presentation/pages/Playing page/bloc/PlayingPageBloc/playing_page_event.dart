part of 'playing_page_bloc.dart';

abstract class PlayingPageEvent extends Equatable {
  const PlayingPageEvent();

  @override
  List<Object> get props => [];
}

class AddSongEvent extends PlayingPageEvent {
  final Song song;
  const AddSongEvent({required this.song});
  @override
  List<Object> get props => [song];
}

class UpdatePlayingPageEvent extends PlayingPageEvent {
  final Song song;
  const UpdatePlayingPageEvent({required this.song});
  @override
  List<Object> get props => [song];
}

class AddNextSongEvent extends PlayingPageEvent {}

class ShowPlayListChoseEvent extends PlayingPageEvent {}

class PlaySongEvent extends PlayingPageEvent {}

class PauseSongEvent extends PlayingPageEvent {}

class SkipToNextEvent extends PlayingPageEvent {}

class SkipToPrevious extends PlayingPageEvent {}

class SeekEvent extends PlayingPageEvent {
  final Duration position;
  const SeekEvent({required this.position});
  @override
  List<Object> get props => [position];
}
