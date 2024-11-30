part of 'top_tile_cubit.dart';

sealed class TopTileState extends Equatable {
  const TopTileState();

  @override
  List<Object> get props => [];
}

final class TopTileInitial extends TopTileState {}

final class TopTileLoading extends TopTileState {}

final class TopTileLoaded extends TopTileState {
  final List<Song> songs;
  const TopTileLoaded({required this.songs});
  @override
  List<Object> get props => [songs];
}
