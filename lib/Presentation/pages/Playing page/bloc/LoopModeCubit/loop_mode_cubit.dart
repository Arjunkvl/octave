import 'package:audio_service/audio_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marshal/application/Services/audio_handler.dart';
import 'package:marshal/application/dependency_injection.dart';

part 'loop_mode_state.dart';

class LoopModeCubit extends Cubit<LoopModeState> {
  LoopModeCubit() : super(LoopModeInitial(loopMode: LoopMode.all));
  final CustmAudioHandler _audioHandler =
      locator<AudioHandler>() as CustmAudioHandler;
  Future<void> setLoopMode({required LoopMode loopMode}) async {
    await _audioHandler.setLoopMode(loopMode);
    emit(LoopModeInitial(loopMode: loopMode));
  }
}
