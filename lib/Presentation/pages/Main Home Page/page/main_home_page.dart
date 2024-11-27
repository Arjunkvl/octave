import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marshal/Presentation/pages/Audio%20Upload%20Page/page/audio_upload_page.dart';
import 'package:marshal/Presentation/pages/Home%20Page/page/home_page.dart';
import 'package:marshal/Presentation/pages/Main%20Home%20Page/bloc/Player%20Controller%20Cubit/player_controller_cubit.dart';
import 'package:marshal/Presentation/pages/Main%20Home%20Page/helpers/variables.dart';
import 'package:marshal/Presentation/pages/Main%20Home%20Page/widgets/player_controller.dart';
import 'package:marshal/Presentation/pages/Search%20Page/page/search_page.dart';
import '../../Home Page/bloc/Play Song Cubit/play_song_cubit.dart';
import '../../Playing page/page/playing_page.dart';

class MainHomePage extends StatelessWidget {
  MainHomePage({super.key});

  final List<Widget> _screens = [
    HomePage(),
    SearchPage(),
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
              if (state is PlayerControllerActive) {
                return PlayerController(
                  song: state.song,
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
          BlocListener<PlaySongCubit, PlaySongState>(
            listener: (context, state) {
              if (state is ShowSongPage) {
                showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return PlayingPage(
                        song: state.song,
                      );
                    });
              }
            },
            child: SizedBox.shrink(),
          ),
        ],
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: index,
        builder: (context, value, _) {
          return BottomNavigationBar(
            fixedColor: Colors.white,
            enableFeedback: true,
            currentIndex: value,
            onTap: (i) {
              index.value = i;
              if (i == 0) {
                FocusScope.of(context).unfocus();
              }
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search), label: 'Search'),
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
