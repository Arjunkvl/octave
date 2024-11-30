part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class UserSignUpEvent extends AuthEvent {
  final String email;
  final String password;

  const UserSignUpEvent({
    required this.email,
    required this.password,
  });
  @override
  List<Object> get props => [];
}

class UserSignInEvent extends AuthEvent {
  final String email;
  final String password;

  const UserSignInEvent({
    required this.email,
    required this.password,
  });
  @override
  List<Object> get props => [];
}
