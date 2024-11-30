part of 'auth_status_checking_cubit.dart';

sealed class AuthStatusCheckingState extends Equatable {
  final bool isLoggedIn;
  const AuthStatusCheckingState({required this.isLoggedIn});

  @override
  List<Object> get props => [];
}

final class AuthStatusCheckingInitial extends AuthStatusCheckingState {
  const AuthStatusCheckingInitial({required super.isLoggedIn});
}
