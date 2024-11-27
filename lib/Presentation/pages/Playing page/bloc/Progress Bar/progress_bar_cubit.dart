import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
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
    AudioService.position.listen(cancelOnError: true, (position) async {
      if (_audioHandler.mediaItem.value == null) {
        log('Is Null Triggered');
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
