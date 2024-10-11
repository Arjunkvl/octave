import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:marshal/Presentation/Theme%20Data/theme_data.dart';
import 'package:marshal/Presentation/pages/Audio%20Upload%20Page/bloc/audio_upload_bloc.dart';
import 'package:marshal/Presentation/pages/Auth/AuthCheckPage/auth_check_page.dart';
import 'package:marshal/Presentation/pages/Auth/AuthCheckPage/cubit/auth_status_checking_cubit.dart';
import 'package:marshal/Presentation/pages/Auth/bloc/auth_bloc.dart';
import 'package:marshal/Presentation/pages/Home%20Page/bloc/Play%20Song%20Cubit/play_song_cubit.dart';
import 'package:marshal/Presentation/pages/Home%20Page/bloc/category%20Cubit/category_cubit.dart';
import 'package:marshal/Presentation/pages/Home%20Page/bloc/Top%20Tile%20Cubit/top_tile_cubit.dart';
import 'package:marshal/Presentation/pages/Home%20Page/bloc/All%20Song/all_songs_cubit.dart';
import 'package:marshal/Presentation/pages/Home%20Page/bloc/greetings%20cubit/greetings_cubit.dart';
import 'package:marshal/Presentation/pages/Main%20Home%20Page/bloc/Player%20Controller%20Cubit/player_controller_cubit.dart';
import 'package:marshal/Presentation/pages/Playing%20page/bloc/Playing%20Page%20Components/playing_page_components_cubit.dart';
import 'package:marshal/application/dependency_injection.dart';
import 'package:marshal/Presentation/pages/Playing%20page/bloc/PlayingPageBloc/playing_page_bloc.dart';
import 'package:marshal/data/models/song_model.dart';
import 'package:marshal/firebase_options.dart';
import 'package:path_provider/path_provider.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: await getApplicationDocumentsDirectory());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  Hive.registerAdapter(SongAdapter());
  // final Box<Song> s = await Hive.openBox('currentlyPlayingSongs');
  // await s.clear();
  setUpLocator();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  runApp(const Marshal());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]);
}

class Marshal extends StatelessWidget {
  const Marshal({super.key});

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   ScreenUtilInit(

    //   );
    // });
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GreetingsCubit(),
        ),
        BlocProvider(
          create: (context) => locator<PlayingPageComponentsCubit>(),
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
          create: (context) => TopTileCubit(),
        ),
        BlocProvider(
          create: (context) => CategoryCubit(),
        ),
        BlocProvider(
          create: (context) => locator<AuthStatusCheckingCubit>(),
        ),
        BlocProvider(
          create: (context) => locator<PlayingPageBloc>(),
        ),
        BlocProvider(
          create: (context) => AudioUploadBloc(),
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
          return MaterialApp(
            theme: AppTheme.theme,
            debugShowCheckedModeBanner: false,
            home: const AuthCheckPage(),
          );
        },
      ),
    );
  }
}
