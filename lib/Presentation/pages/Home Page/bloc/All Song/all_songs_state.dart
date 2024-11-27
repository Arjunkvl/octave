part of 'all_songs_cubit.dart';

sealed class AllSongsState extends Equatable {
  final List<Song> songs;
  AllSongsState({required this.songs});
  @override
  List<Object> get props => [songs];
}

final class AllSongsInitial extends AllSongsState {
  AllSongsInitial({required super.songs});
}

final class AllSongLoading extends AllSongsState {
  AllSongLoading({required super.songs});
}

final class NoSongFoundState extends AllSongsState {
  NoSongFoundState({required super.songs});
}

final class AllSongsLoaded extends AllSongsState {
  AllSongsLoaded({required super.songs});
}
