import 'dart:developer';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marshal/Presentation/Icons/icon_data.dart';
import 'package:marshal/Presentation/pages/Auth/bloc/auth_bloc.dart';
import 'package:marshal/Presentation/pages/Main%20Home%20Page/page/main_home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
      appBar: AppBar(
        leadingWidth: 32,
        backgroundColor: Colors.transparent,
      ),
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
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
                totalRepeatCount: 1,
                animatedTexts: [
                  TyperAnimatedText("Let's Get You Signed Up",
                      textStyle: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
              SizedBox(
                height: 72.h,
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
                      height: 27.h,
                    ),
                    Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: TextFormField(
                        validator: (value) {
                          if (value != _password.text) {
                            return "Password does not match.";
                          } else {
                            return null;
                          }
                        },
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
                            'Conform',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    BlocListener<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is SignUpFailed) {
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
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => MainHomePage(),
                            ),
                          );
                        }
                      },
                      child: GestureDetector(
                        onTap: () {
                          if (_email.text != '' && _password.text != '') {
                            context.read<AuthBloc>().add(
                                  UserSignUpEvent(
                                    email: _email.text,
                                    password: _password.text,
                                  ),
                                );
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
                              "SignUp",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60.h,
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
    log('dispose');
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
}
