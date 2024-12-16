import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:marshal/Presentation/Icons/icon_data.dart';
import 'package:marshal/Presentation/pages/Auth/bloc/auth_bloc.dart';

import '../../../../../application/Routing/routes.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late TextEditingController _email;

  late TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController(text: '');
    _password = TextEditingController(text: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 60.h),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppIcons.appIcon,
                width: 120.w,
              ),
              const SizedBox(
                height: 45,
              ),
              AnimatedTextKit(
                totalRepeatCount: 2,
                animatedTexts: [
                  TyperAnimatedText("Octave.",
                      textStyle: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
              SizedBox(
                height: 90.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Column(
                  children: [
                    TextField(
                      controller: _email,
                      decoration: InputDecoration(
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.white,
                          )),
                          enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.white,
                          )),
                          alignLabelWithHint: true,
                          label: Text('Email',
                              style: Theme.of(context).textTheme.bodyMedium)),
                    ),
                    SizedBox(
                      height: 27.h,
                    ),
                    TextField(
                      controller: _password,
                      decoration: InputDecoration(
                        focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.white,
                        )),
                        enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.white,
                        )),
                        alignLabelWithHint: true,
                        label: Text(
                          'Password',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    BlocListener<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is SignInFailed) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            content: Text(
                              state.errorMsg,
                              style: const TextStyle(color: Colors.white),
                            ),
                            margin: EdgeInsets.all(15.w),
                          ));
                        }
                        if (state is LogedInState) {
                          context.pushReplacement(Routes.homePage);
                        }
                      },
                      child: GestureDetector(
                        onTap: () async {
                          if (_email.text != '' && _password.text != '') {
                            if (context.mounted) {
                              context.read<AuthBloc>().add(
                                    UserSignInEvent(
                                      email: _email.text,
                                      password: _password.text,
                                    ),
                                  );
                            }
                          }
                        },
                        child: Container(
                          width: double.maxFinite,
                          height: 57.h,
                          decoration: BoxDecoration(
                            color: const Color(0xff00FF57),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              "SignIn",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        GestureDetector(
                          onTap: () {
                            context.push(Routes.signUpPage);
                          },
                          child: const Text(
                            "Sign Up!",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
}
