import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:marshal/Presentation/pages/Audio%20Upload%20Page/page/audio_upload_page.dart';
import 'package:marshal/Presentation/pages/Home%20Page/page/home_page.dart';
import 'package:marshal/Presentation/pages/Main%20Home%20Page/bloc/Player%20Controller%20Cubit/player_controller_cubit.dart';
import 'package:marshal/Presentation/pages/Main%20Home%20Page/helpers/variables.dart';
import 'package:marshal/Presentation/pages/Main%20Home%20Page/widgets/player_controller.dart';

class MainHomePage extends StatelessWidget {
  MainHomePage({super.key});

  final List<Widget> _screens = [
    HomePage(),
    AudioUploadPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          ValueListenableBuilder(
              valueListenable: index, builder: (context, i, _) => _screens[i]),
          BlocBuilder<PlayerControllerCubit, PlayerControllerState>(
            builder: (context, state) {
              log('gyguigulg');
              if (state is PlayerControllerActive) {
                log('player active');
                return PlayerController(
                  song: state.song,
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: index,
        builder: (context, value, _) {
          return BottomNavigationBar(
            enableFeedback: true,
            currentIndex: value,
            onTap: (i) {
              index.value = i;
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.upload_file), label: 'Upload')
            ],
            backgroundColor: Colors.transparent,
          );
        },
      ),
    );
  }
}
