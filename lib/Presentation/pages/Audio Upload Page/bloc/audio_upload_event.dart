part of 'audio_upload_bloc.dart';

abstract class AudioUploadEvent extends Equatable {
  const AudioUploadEvent();

  @override
  List<Object> get props => [];
}

class ExtractMetadataEvent extends AudioUploadEvent {
  final File audioFile;
  const ExtractMetadataEvent({required this.audioFile});
  @override
  List<Object> get props => [audioFile];
}

class UploadAudioEvent extends AudioUploadEvent {
  final File audioFile;
  final ID3Tag tag;
  const UploadAudioEvent({required this.tag, required this.audioFile});
  @override
  List<Object> get props => [audioFile, tag];
}

class ShowInitialFaceEvent extends AudioUploadEvent {}
