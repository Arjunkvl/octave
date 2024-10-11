part of 'all_songs_cubit.dart';

sealed class AllSongsState extends Equatable {
  const AllSongsState();

  @override
  List<Object> get props => [];
}

final class AllSongsInitial extends AllSongsState {}

final class AllSongLoading extends AllSongsState {}

final class AllSongsLoaded extends AllSongsState {
  final List<Song> songs;
  AllSongsLoaded({required this.songs});
  @override
  List<Object> get props => [songs];
}
