part of 'playing_page_bloc.dart';

abstract class PlayingPageState extends Equatable {
  const PlayingPageState();

  @override
  List<Object> get props => [];
}

class PlayingPageInitial extends PlayingPageState {}

class PlayingState extends PlayingPageState {
  final Song song;
  PlayingState({required this.song});
  @override
  List<Object> get props => [song];
}
