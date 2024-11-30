part of 'player_controller_cubit.dart';

class PlayerControllerState extends Equatable {
  const PlayerControllerState();

  @override
  List<Object> get props => [];
}

final class PlayerControllerInActive extends PlayerControllerState {}

final class PlayerControllerActive extends PlayerControllerState {
  final Song song;
  const PlayerControllerActive({required this.song});
  @override
  List<Object> get props => [song];
}
