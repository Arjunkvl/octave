part of 'playing_page_bloc.dart';

abstract class PlayingPageState extends Equatable {
  const PlayingPageState();

  @override
  List<Object> get props => [];
}

class PlayingPageInitial extends PlayingPageState {}

class UpdatedPlayerBar extends PlayingPageState {
  final PlayerDetailsEntitiy playerDetailsEntitiy;

  UpdatedPlayerBar({required this.playerDetailsEntitiy});
  @override
  List<Object> get props => [playerDetailsEntitiy];
}
