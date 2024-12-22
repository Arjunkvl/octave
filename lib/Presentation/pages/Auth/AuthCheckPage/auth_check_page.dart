import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marshal/Presentation/pages/Auth/AuthCheckPage/cubit/auth_status_checking_cubit.dart';
import 'package:marshal/application/Services/Spotify/spotify_api.dart';

import '../../../../application/Routing/routes.dart';

class AuthCheckPage extends StatelessWidget {
  const AuthCheckPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthStatusCheckingCubit>().checkAuthState();
    SpotifyService().fetchSpotifyApiToken();
    return Scaffold(
        body: BlocListener<AuthStatusCheckingCubit, AuthStatusCheckingState>(
      listener: (context, state) {
        if (state.isLoggedIn) {
          context.pushReplacement(Routes.homePage);
        } else {
          context.pushReplacement(Routes.signInPage);
        }
      },
      child: const SizedBox(),
    ));
  }
}
