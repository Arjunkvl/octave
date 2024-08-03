import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'greetings_state.dart';

class GreetingsCubit extends Cubit<GreetingsState> {
  GreetingsCubit() : super(GreetingsInitial(greeting: '.......'));
  void setGreeting() {
    TimeOfDay now = TimeOfDay.now();
    if (now.hour > 0 && now.hour < 12) {
      emit(
        GreetingsInitial(greeting: 'Good morning'),
      );
    } else if (now.hour > 12 && now.hour < 16) {
      emit(
        GreetingsInitial(greeting: 'Good afternoon'),
      );
    } else {
      emit(
        GreetingsInitial(greeting: 'Good evening'),
      );
    }
  }
}
