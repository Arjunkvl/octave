import 'dart:io';
import 'dart:typed_data';

import 'package:audiotags/audiotags.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marshal/application/dependency_injection.dart';
import 'package:marshal/domain/Usecases/audio%20manage%20usecases/audio_usecases.dart';

part 'audio_upload_event.dart';
part 'audio_upload_state.dart';

class AudioUploadBloc extends Bloc<AudioUploadEvent, AudioUploadState> {
  AudioUploadBloc() : super(AudioUploadInitial()) {
    on<ExtractMetadataEvent>((event, emit) async {
      Option<Tag> result =
          await locator<ExtractAudioMetadata>().call(event.audioFile);
      result.fold(() {
        (i) {
          emit(AudioUploadInitial());
        };
      }, (tag) {
        emit(UploadeState(tag: tag, isCompleted: false));
      });
    });
    on<UploadAudioEvent>((event, emit) async {
      // String songId = DateTime.now().microsecondsSinceEpoch.toString();
      Uint8List idGList = await event.audioFile.readAsBytes();
      String songId = idGList.sublist(0, 20).join('');
      UploadTask uploadTask = await locator<UploadAudio>()
          .call(audioFile: event.audioFile, songId: songId, tag: event.tag);
      await for (final taskSnapshot in uploadTask.snapshotEvents) {
        if (taskSnapshot.state == TaskState.success) {
          await locator<UploadEssentials>()
              .call(songId: songId, tag: event.tag);
          emit(UploadeState(isCompleted: true, tag: event.tag));
        }
      }
    });
  }
}
