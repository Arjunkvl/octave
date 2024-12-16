import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marshal/Presentation/Theme%20Data/theme_data.dart';
import 'package:marshal/Presentation/pages/Audio%20Upload%20Page/bloc/audio_upload_bloc.dart';
import 'package:marshal/Presentation/pages/Auth/AuthCheckPage/cubit/auth_status_checking_cubit.dart';
import 'package:marshal/Presentation/pages/Auth/bloc/auth_bloc.dart';
import 'package:marshal/Presentation/pages/Home%20Page/bloc/Play%20Song%20Cubit/play_song_cubit.dart';
import 'package:marshal/Presentation/pages/Home%20Page/bloc/category%20Cubit/category_cubit.dart';
import 'package:marshal/Presentation/pages/Home%20Page/bloc/Top%20Tile%20Cubit/top_tile_cubit.dart';
import 'package:marshal/Presentation/pages/Home%20Page/bloc/All%20Song/all_songs_cubit.dart';
import 'package:marshal/Presentation/pages/Home%20Page/bloc/greetings%20cubit/greetings_cubit.dart';
import 'package:marshal/Presentation/pages/Library%20page/bloc/Library%20Bloc/library_bloc.dart';
import 'package:marshal/Presentation/pages/Main%20Home%20Page/bloc/BottomNavCubit/bottom_nav_cubit.dart';
import 'package:marshal/Presentation/pages/Main%20Home%20Page/bloc/Player%20Controller%20Cubit/player_controller_cubit.dart';
import 'package:marshal/Presentation/pages/Playing%20page/bloc/LoopModeCubit/loop_mode_cubit.dart';
import 'package:marshal/Presentation/pages/Playing%20page/bloc/Progress%20Bar/progress_bar_cubit.dart';
import 'package:marshal/Presentation/pages/Playing%20page/bloc/cubit/add_to_play_list_cubit.dart';
import 'package:marshal/Presentation/pages/Search%20Page/cubit/Response%20Songs/response_songs_cubit.dart';
import 'package:marshal/application/Routing/router.dart';
import 'package:marshal/application/Services/Spotify/spotify_api.dart';
import 'package:marshal/application/dependency_injection.dart';
import 'package:marshal/Presentation/pages/Playing%20page/bloc/PlayingPageBloc/playing_page_bloc.dart';
import 'package:marshal/core/hive_registration.dart';
import 'package:marshal/firebase_options.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setUpLocator();
  await hiveStartUp();
  SpotifyService().fetchSpotifyApiToken();
  runApp(const Marshal());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]);
}

class Marshal extends StatelessWidget {
  const Marshal({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GreetingsCubit(),
        ),
        BlocProvider(
          create: (context) => BottomNavCubit(),
        ),
        BlocProvider(
          create: (context) => ResponseSongsCubit(),
        ),
        BlocProvider(
          create: (context) => ProgressBarCubit()..listenToCurrentPosition(),
        ),
        BlocProvider(
          create: (context) => locator<PlayerControllerCubit>(),
        ),
        BlocProvider(
          create: (context) => PlaySongCubit(),
        ),
        BlocProvider(
          create: (context) => AllSongsCubit(),
        ),
        BlocProvider(
          create: (context) => LoopModeCubit(),
        ),
        BlocProvider(
          create: (context) => TopTileCubit(),
        ),
        BlocProvider(
          create: (context) => CategoryCubit(),
        ),
        BlocProvider(
          create: (context) => AddToPlayListCubit(),
        ),
        BlocProvider(
          create: (context) =>
              AuthStatusCheckingCubit(SchedulerBinding.instance),
        ),
        BlocProvider(
          create: (context) => locator<PlayingPageBloc>(),
        ),
        BlocProvider(
          create: (context) => AudioUploadBloc(),
        ),
        BlocProvider(
          create: (context) => LibraryBloc(),
        ),
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 800),
        splitScreenMode: true,
        minTextAdapt: true,
        builder: (context, _) {
          return MaterialApp.router(
            routerConfig: router,
            theme: AppTheme.theme,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
