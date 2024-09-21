import 'dart:io';

import 'package:audiotags/audiotags.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class AudioManageRepo {
  Future<Option<Tag>> extractAudioMetadata(File audioFile);
  Future<UploadTask> uploadAudio(
      {required File audioFile, required songId, required Tag tag});
  Future<void> uploadEssentials({required String songId, required Tag tag});
}
