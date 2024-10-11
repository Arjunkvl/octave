import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marshal/data/models/song_model.dart';

part 'player_controller_state.dart';

class PlayerControllerCubit extends Cubit<PlayerControllerState> {
  PlayerControllerCubit() : super(PlayerControllerInActive());
  void showPlayerController({required Song song}) {
    emit(PlayerControllerActive(song: song));
  }
}
