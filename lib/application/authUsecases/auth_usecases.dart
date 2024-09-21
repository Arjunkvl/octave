import 'package:dartz/dartz.dart';
import 'package:marshal/application/authRepo/auth_repo.dart';
import 'package:marshal/application/authRepo/auth_states.dart';

class GetUserSignedUp {
  final AuthRepo authRepo;
  GetUserSignedUp({required this.authRepo});
  Future<Either<AuthFaliure, AuthSuccess>> call(
      {required email, required password}) async {
    return await authRepo.getUserSignedUp(email: email, password: password);
  }
}

class UserSignIn {
  final AuthRepo authRepo;
  UserSignIn({required this.authRepo});
  Future<Either<AuthFaliure, AuthSuccess>> call(
      {required email, required password}) async {
    return await authRepo.userSignIn(email: email, password: password);
  }
}
