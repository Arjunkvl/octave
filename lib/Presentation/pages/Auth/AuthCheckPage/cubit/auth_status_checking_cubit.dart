import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_status_checking_state.dart';

class AuthStatusCheckingCubit extends Cubit<AuthStatusCheckingState> {
  final SchedulerBinding _schedulerBinding;
  AuthStatusCheckingCubit(this._schedulerBinding)
      : super(AuthStatusCheckingInitial(isLoggedIn: false));

  void checkAuthState() {
    _schedulerBinding.addPostFrameCallback((_) {
      if (FirebaseAuth.instance.currentUser == null) {
        emit(AuthStatusCheckingInitial(isLoggedIn: false));
      } else {
        emit(AuthStatusCheckingInitial(isLoggedIn: true));
      }
    });
  }
}
