part of 'greetings_cubit.dart';

sealed class GreetingsState extends Equatable {
  final String greeting;
  const GreetingsState({required this.greeting});

  @override
  List<Object> get props => [];
}

final class GreetingsInitial extends GreetingsState {
  GreetingsInitial({required super.greeting});
}
