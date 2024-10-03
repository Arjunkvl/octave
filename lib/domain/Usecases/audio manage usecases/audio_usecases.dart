import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:id3tag/id3tag.dart';
import 'package:marshal/data/models/song_model.dart';
import 'package:marshal/data/repository/Audio%20Manage%20Repo/audio_manage_impl.dart';

class ExtractAudioMetadata {
  final AudioManageImpl repository;
  ExtractAudioMetadata({required this.repository});
  Future<Option<ID3Tag>> call(File audioFile) async {
    return await repository.extractAudioMetadata(audioFile);
  }
}

class UploadAudio {
  final AudioManageImpl repository;
  UploadAudio({required this.repository});
  Future<UploadTask> call(
      {required File audioFile, required songId, required ID3Tag tag}) async {
    return await repository.uploadAudio(
        audioFile: audioFile, songId: songId, tag: tag);
  }
}

class UploadEssentials {
  final AudioManageImpl repository;
  UploadEssentials({required this.repository});
  Future<void> call({required String songId, required ID3Tag tag}) async {
    await repository.uploadEssentials(songId: songId, tag: tag);
  }
}

class UploadToRecentSongs {
  final AudioManageImpl repository;
  UploadToRecentSongs({required this.repository});
  Future<void> call({required String songId}) async {
    await repository.uploadToRecentSongs(songId: songId);
  }
}
