part of 'loop_mode_cubit.dart';

sealed class LoopModeState extends Equatable {
  final LoopMode loopMode;
  const LoopModeState({required this.loopMode});

  @override
  List<Object> get props => [loopMode];
}

final class LoopModeInitial extends LoopModeState {
  const LoopModeInitial({required super.loopMode});
  @override
  List<Object> get props => [loopMode];
}
