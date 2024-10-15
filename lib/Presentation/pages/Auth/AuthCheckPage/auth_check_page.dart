import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marshal/Presentation/pages/Auth/AuthCheckPage/cubit/auth_status_checking_cubit.dart';
import 'package:marshal/Presentation/pages/Auth/SignIn%20Page/page/sign_in_page.dart';
import 'package:marshal/Presentation/pages/Main%20Home%20Page/page/main_home_page.dart';

class AuthCheckPage extends StatelessWidget {
  const AuthCheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthStatusCheckingCubit>().checkAuthState();
    return Scaffold(
        body: BlocListener<AuthStatusCheckingCubit, AuthStatusCheckingState>(
      listener: (context, state) {
        if (state.isLoggedIn) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => MainHomePage(),
            ),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const SignInPage(),
            ),
          );
        }
      },
      child: const SizedBox(),
    ));
  }
}
