part of 'song_cubit.dart';

class SongState extends Equatable {
  const SongState();

  @override
  List<Object> get props => [];
}

final class SongInitial extends SongState {}

final class SongLoading extends SongState {}

final class SongLoaded extends SongState {
  final List<Song> songs;
  SongLoaded({required this.songs});
  @override
  List<Object> get props => [songs];
}

final class SongError extends SongState {}
