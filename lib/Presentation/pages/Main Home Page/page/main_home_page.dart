import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marshal/Presentation/pages/Home%20Page/bloc/Play%20Song%20Cubit/play_song_cubit.dart';
import 'package:marshal/Presentation/pages/Main%20Home%20Page/bloc/Player%20Controller%20Cubit/player_controller_cubit.dart';
import 'package:marshal/Presentation/pages/Main%20Home%20Page/widgets/player_controller.dart';
import 'package:marshal/Presentation/pages/Playing%20page/page/playing_page.dart';
import 'package:marshal/application/Routing/destinations.dart';

class MainHomePage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const MainHomePage({required this.navigationShell, Key? key})
      : super(key: key ?? const ValueKey<String>('MainHomePage'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          navigationShell,
          BlocBuilder<PlayerControllerCubit, PlayerControllerState>(
            builder: (context, state) {
              if (state is PlayerControllerActive) {
                return PlayerController(song: state.song);
              } else {
                return SizedBox.shrink();
              }
            },
          ),
          BlocListener<PlaySongCubit, PlaySongState>(
            listener: (context, state) async {
              if (state is ShowSongPage) {
                await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return PlayingPage(song: state.song);
                    });
              }
            },
            child: SizedBox.shrink(),
          )
        ],
      ),
      bottomNavigationBar: NavigationBar(
        animationDuration: Duration(milliseconds: 700),
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (i) {
          navigationShell.goBranch(i);
          if (i == 0) {
            FocusScope.of(context).unfocus();
          }
        },
        indicatorColor: Colors.grey,
        backgroundColor: Colors.black,
        destinations: destinations
            .map((destination) => NavigationDestination(
                icon: destination.icon, label: destination.label))
            .toList(),
      ),
    );
  }
}
