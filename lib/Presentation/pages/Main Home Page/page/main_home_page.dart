import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marshal/Presentation/pages/Audio%20Upload%20Page/page/audio_upload_page.dart';
import 'package:marshal/Presentation/pages/Home%20Page/page/home_page.dart';
import 'package:marshal/Presentation/pages/Library%20Page/page/library_page.dart';
import 'package:marshal/Presentation/pages/Library%20page/bloc/Library%20Bloc/library_bloc.dart';
import 'package:marshal/Presentation/pages/Main%20Home%20Page/bloc/BottomNavCubit/bottom_nav_cubit.dart';
import 'package:marshal/Presentation/pages/Main%20Home%20Page/bloc/Player%20Controller%20Cubit/player_controller_cubit.dart';
import 'package:marshal/Presentation/pages/Main%20Home%20Page/widgets/player_controller.dart';
import 'package:marshal/Presentation/pages/Play%20List%20Page/page/play_list_page.dart';
import 'package:marshal/Presentation/pages/Search%20Page/page/search_page.dart';
import 'package:marshal/data/models/PlayList%20Model/playlist_model.dart';
import '../../Home Page/bloc/Play Song Cubit/play_song_cubit.dart';
import '../../Playing page/page/playing_page.dart';

class MainHomePage extends StatelessWidget {
  MainHomePage({super.key});

  final List<Widget> _screens = [
    HomePage(),
    SearchPage(),
    LibraryPage(),
    AudioUploadPage(),
    PlayListPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            BlocBuilder<BottomNavCubit, BottomNavState>(
                builder: (context, state) => _screens[state.index]),
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
                if (state is PlayListEdit) {
                  TextEditingController textController =
                      TextEditingController();
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => Container(
                      height: 500.h,
                      width: double.infinity,
                      color: Colors.black,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Create A PlayList',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          SizedBox(
                            height: 50.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextField(
                              controller: textController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Title',
                                hintStyle:
                                    Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ),
                          MaterialButton(
                            color: Colors.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100)),
                            onPressed: () {
                              context.read<LibraryBloc>().add(
                                    AddPlayListEvent(
                                      playlist: Playlist(
                                        title: textController.value.text,
                                        cover: '',
                                        songs: [],
                                      ),
                                    ),
                                  );
                              context
                                  .read<LibraryBloc>()
                                  .add(GetPlayListsEvent());
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Create',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
              },
              child: SizedBox.shrink(),
            ),
          ],
        ),
        bottomNavigationBar: BlocBuilder<BottomNavCubit, BottomNavState>(
            builder: (context, state) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            fixedColor: Colors.white,
            enableFeedback: true,
            currentIndex: state.index < 3 ? state.index : 0,
            onTap: (i) {
              context.read<BottomNavCubit>().setIndex(index: i);
              if (i == 0) {
                FocusScope.of(context).unfocus();
              }
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search), label: 'Search'),
              BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.book), label: 'Library'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.upload_file), label: 'Upload')
            ],
            backgroundColor: Colors.transparent,
          );
        }));
  }
}
