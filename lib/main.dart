import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:marshal/Presentation/Theme%20Data/theme_data.dart';
import 'package:marshal/Presentation/pages/Home%20Page/bloc/HomePageBloc/home_page_bloc.dart';
import 'package:marshal/Presentation/pages/Home%20Page/bloc/greetings%20cubit/greetings_cubit.dart';
import 'package:marshal/Presentation/pages/Home%20Page/page/home_page.dart';
import 'package:marshal/application/dependency_injection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:marshal/Presentation/pages/Playing%20page/bloc/PlayingPageBloc/playing_page_bloc.dart';
// import 'package:marshal/Presentation/pages/Home%20Page/page/home_page.dart';
import 'package:marshal/firebase_options.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );
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
            create: (context) => locator<PlayingPageBloc>(),
          ),
          BlocProvider(
            create: (context) => locator<HomePageBloc>(),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.theme,
          debugShowCheckedModeBanner: false,
          home: const HomePage(),
          // builder: (context, child) {
          //   return Scaffold(
          //     body: Container(
          //       width: 300.w,
          //       height: 50.h,
          //       color: Colors.blue,
          //       child: Text('data'),
          //     ),
          //   );
          // },
        ),
      ),
    );
  }
}
