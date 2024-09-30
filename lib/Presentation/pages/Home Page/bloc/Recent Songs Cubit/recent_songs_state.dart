part of 'recent_songs_cubit.dart';

class RecentSongsState extends Equatable {
  const RecentSongsState();

  @override
  List<Object> get props => [];
}

class RecentSongsInitial extends RecentSongsState {}

class ReacentSongsLoading extends RecentSongsState {}

class RecentSongLoaded extends RecentSongsState {
  final List<Song> songs;
  RecentSongLoaded({required this.songs});
  @override
  List<Object> get props => [songs];
}
