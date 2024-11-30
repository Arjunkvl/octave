part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class SignUpInitial extends AuthState {}

class ProcessignState extends AuthState {}

class LogedInState extends AuthState {}

class SignInFailed extends AuthState {
  final String errorMsg;
  const SignInFailed({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}

class SignUpFailed extends AuthState {
  final String errorMsg;
  const SignUpFailed({required this.errorMsg});
  @override
  List<Object> get props => [errorMsg];
}
