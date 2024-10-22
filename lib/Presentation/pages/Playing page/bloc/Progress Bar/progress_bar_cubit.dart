import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marshal/Presentation/pages/Playing%20page/bloc/PlayingPageBloc/playing_page_bloc.dart';
import 'package:marshal/Presentation/pages/Playing%20page/helpers/player_bar_entity.dart';
import 'package:marshal/application/dependency_injection.dart';

part 'progress_bar_state.dart';

class ProgressBarCubit extends Cubit<ProgressBarState> {
  final AudioHandler _audioHandler = locator<AudioHandler>();
  ProgressBarCubit()
      : super(ProgressBarInitial(
            playerBarEntity: PlayerBarEntity(
                currentDuration: Duration.zero, totalDuration: Duration.zero)));
  void listenToCurrentPosition() {
    AudioService.position.listen((position) async {
      if (_audioHandler.mediaItem.value!.duration == null) {
        return;
      }
      if (_audioHandler.mediaItem.value!.duration! - position <=
          Duration(seconds: 3)) {
        locator<PlayingPageBloc>().add(SkipToNextEvent());
        return;
      }
      emit(ProgressBarInitial(
          playerBarEntity: PlayerBarEntity(
              currentDuration: position,
              totalDuration:
                  _audioHandler.mediaItem.value!.duration ?? Duration.zero)));
    });
  }
}
