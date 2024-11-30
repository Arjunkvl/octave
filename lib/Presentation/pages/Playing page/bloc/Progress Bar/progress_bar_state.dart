part of 'progress_bar_cubit.dart';

sealed class ProgressBarState extends Equatable {
  const ProgressBarState();

  @override
  List<Object> get props => [];
}

final class ProgressBarInitial extends ProgressBarState {
  final PlayerBarEntity playerBarEntity;
  const ProgressBarInitial({required this.playerBarEntity});
  @override
  List<Object> get props => [playerBarEntity];
}
