part of 'playing_page_bloc.dart';

abstract class PlayingPageState extends Equatable {
  const PlayingPageState();

  @override
  List<Object> get props => [];
}

class PlayingPageInitial extends PlayingPageState {}

class PlayingPageForceLoadingState extends PlayingPageState {
  final Song song;
  const PlayingPageForceLoadingState({required this.song});
  @override
  List<Object> get props => [song];
}

class PlayingState extends PlayingPageState {
  final Song song;
  const PlayingState({required this.song});
  @override
  List<Object> get props => [song];
}
