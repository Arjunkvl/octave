import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:marshal/application/authRepo/auth_states.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  Future<Either<AuthFaliure, AuthSuccess>> getUserSignedUp(
      {required String email, required String password}) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (error) {
      final String errorMsg = error.toString().split(']')[1];
      return Left(AuthFaliure(errorMsg: errorMsg));
    }

    storage.setString('uid', FirebaseAuth.instance.currentUser!.uid);
    return Right(AuthSuccess());
  }

  Future<Either<AuthFaliure, AuthSuccess>> userSignIn(
      {required email, required password}) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (error) {
      final String errorMsg = error.toString().split(']')[1];
      return Left(AuthFaliure(errorMsg: errorMsg));
    }
    storage.setString('uid', FirebaseAuth.instance.currentUser!.uid);
    return Right(AuthSuccess());
  }
  //nee to implement more sign in options;
}
