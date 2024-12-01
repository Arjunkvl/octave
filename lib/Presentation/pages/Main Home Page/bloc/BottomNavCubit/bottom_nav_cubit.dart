import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'bottom_nav_state.dart';

class BottomNavCubit extends Cubit<BottomNavState> {
  BottomNavCubit() : super(BottomNavIndexState(index: 0));
  void setIndex({required int index}) =>
      emit(BottomNavIndexState(index: index));
}
