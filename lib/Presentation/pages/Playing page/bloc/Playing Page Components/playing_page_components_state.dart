part of 'playing_page_components_cubit.dart';

class PlayingPageComponentsState extends Equatable {
  const PlayingPageComponentsState();

  @override
  List<Object> get props => [];
}

final class PlayingPageComponentsInitial extends PlayingPageComponentsState {}

final class SongComponentsState extends PlayingPageComponentsState {
  final Song song;
  SongComponentsState({required this.song});
  @override
  List<Object> get props => [song];
}
