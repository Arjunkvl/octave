import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:id3tag/id3tag.dart';
import 'package:marshal/application/dependency_injection.dart';
import 'package:marshal/domain/Usecases/audio%20manage%20usecases/audio_usecases.dart';

part 'audio_upload_event.dart';
part 'audio_upload_state.dart';

class AudioUploadBloc extends Bloc<AudioUploadEvent, AudioUploadState> {
  AudioUploadBloc() : super(AudioUploadInitial()) {
    on<ExtractMetadataEvent>((event, emit) async {
      Option<ID3Tag> result =
          await locator<ExtractAudioMetadata>().call(event.audioFile);
      result.fold(() {
        (i) {
          emit(UploadErrorState());
        };
      }, (tag) {
        // emit(UploadeState(tag: tag, isCompleted: false));
        emit(UploadeState(
            isCompleted: false, tag: tag, audioFile: event.audioFile));
      });
    });
    on<UploadAudioEvent>((event, emit) async {
      emit(Uploading());
      String songId = FirebaseFirestore.instance.collection('songs').doc().id;
      final String fileHash =
          await locator<GenerateFileHash>().call(file: event.audioFile);
      Option<UploadTask> result = await locator<UploadAudio>().call(
          audioFile: event.audioFile,
          songId: songId,
          tag: event.tag,
          fileHash: fileHash);
      await result.fold(() async {
        emit(UploadErrorState());
      }, (uploadTask) async {
        await for (final taskSnapshot in uploadTask.snapshotEvents) {
          if (taskSnapshot.state == TaskState.success) {
            await locator<UploadEssentials>()
                .call(songId: songId, tag: event.tag, fileHash: fileHash);
          }
        }
        emit(UploadCompletedState());
      });
    });
  }
}
