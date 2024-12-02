part of 'bottom_nav_cubit.dart';

sealed class BottomNavState extends Equatable {
  final int index;
  const BottomNavState({required this.index});

  @override
  List<Object> get props => [];
}

final class BottomNavIndexState extends BottomNavState {
  const BottomNavIndexState({required super.index});
  @override
  List<Object> get props => [index];
}

final class PlayListShowState extends BottomNavState {
  final Playlist playList;
  const PlayListShowState({super.index = 0, required this.playList});
}
