part of 'audio_upload_bloc.dart';

abstract class AudioUploadEvent extends Equatable {
  const AudioUploadEvent();

  @override
  List<Object> get props => [];
}

class ExtractMetadataEvent extends AudioUploadEvent {
  final File audioFile;
  ExtractMetadataEvent({required this.audioFile});
  @override
  List<Object> get props => [audioFile];
}

class UploadAudioEvent extends AudioUploadEvent {
  final File audioFile;
  final Tag tag;
  UploadAudioEvent({required this.tag, required this.audioFile});
  @override
  List<Object> get props => [audioFile, tag];
}
