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
import 'package:marshal/Presentation/pages/Home%20Page/bloc/category%20Cubit/category_cubit.dart';
import 'package:marshal/Presentation/pages/Home%20Page/bloc/cubit/top_tile_cubit.dart';
import 'package:marshal/Presentation/pages/Home%20Page/bloc/greetings%20cubit/greetings_cubit.dart';
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
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
}

class Marshal extends StatelessWidget {
  const Marshal({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      splitScreenMode: true,
      minTextAdapt: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => GreetingsCubit(),
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
            lazy: false,
            create: (context) =>
                locator<PlayingPageBloc>()..add(AddSongsEvent()),
          ),
          BlocProvider(
            create: (context) => AudioUploadBloc(),
          ),
          BlocProvider(
            create: (context) => AuthBloc(),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.theme,
          debugShowCheckedModeBanner: false,
          home: const AuthCheckPage(),
        ),
      ),
    );
  }
}
