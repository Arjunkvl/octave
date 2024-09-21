import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marshal/application/authRepo/auth_states.dart';
import 'package:marshal/application/authUsecases/auth_usecases.dart';
import 'package:marshal/application/dependency_injection.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(SignUpInitial()) {
    on<UserSignUpEvent>((event, emit) async {
      emit(ProcessignState());
      Either<AuthFaliure, AuthSuccess> status =
          await locator<GetUserSignedUp>().call(
        email: event.email,
        password: event.password,
      );
      status.fold((authFaliure) {
        emit(SignUpFailed(errorMsg: authFaliure.errorMsg));
      }, (authSuccess) {
        emit(LogedInState());
      });
    });
    on<UserSignInEvent>((event, emit) async {
      emit(ProcessignState());
      Either<AuthFaliure, AuthSuccess> status = await locator<UserSignIn>()
          .call(email: event.email, password: event.password);
      status.fold((authFaliure) {
        emit(SignInFailed(errorMsg: authFaliure.errorMsg));
      }, (authSuccess) {
        emit(LogedInState());
      });
    });
  }
}
