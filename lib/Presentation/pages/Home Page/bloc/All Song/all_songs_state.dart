part of 'all_songs_cubit.dart';

sealed class AllSongsState extends Equatable {
  final List<Song> songs;
  const AllSongsState({required this.songs});
  @override
  List<Object> get props => [songs];
}

final class AllSongsInitial extends AllSongsState {
  const AllSongsInitial({required super.songs});
}

final class AllSongLoading extends AllSongsState {
  const AllSongLoading({required super.songs});
}

final class NoSongFoundState extends AllSongsState {
  const NoSongFoundState({required super.songs});
}

final class AllSongsLoaded extends AllSongsState {
  const AllSongsLoaded({required super.songs});
}
