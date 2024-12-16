import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:marshal/Presentation/pages/Audio%20Upload%20Page/page/audio_upload_page.dart';
import 'package:marshal/Presentation/pages/Auth/AuthCheckPage/auth_check_page.dart';
import 'package:marshal/Presentation/pages/Auth/SignUp%20Page/page/sign_up_page.dart';
import 'package:marshal/Presentation/pages/Create%20PlayList%20Page/Page/create_playlist_page.dart';
import 'package:marshal/Presentation/pages/Home%20Page/page/home_page.dart';
import 'package:marshal/Presentation/pages/Library%20page/page/library_page.dart';
import 'package:marshal/Presentation/pages/Main%20Home%20Page/page/main_home_page.dart';
import 'package:marshal/Presentation/pages/Play%20List%20Page/page/play_list_page.dart';
import 'package:marshal/Presentation/pages/Search%20Page/page/search_page.dart';
import 'package:marshal/application/Routing/routes.dart';

import '../../Presentation/pages/Auth/SignIn Page/page/sign_in_page.dart';
import '../../data/models/PlayList Model/playlist_model.dart';

final GlobalKey<NavigatorState> _rootNavKey = GlobalKey<NavigatorState>();

final router = GoRouter(
    navigatorKey: _rootNavKey,
    initialLocation: Routes.authCheckPage,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => MainHomePage(
          navigationShell: navigationShell,
        ),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.homePage,
              builder: (context, state) {
                FocusScope.of(context).unfocus();
                return HomePage();
              },
            )
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.searchPage,
              builder: (context, state) => SearchPage(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.libraryPage,
              builder: (context, state) => LibraryPage(),
              routes: [
                GoRoute(
                  path: Routes.playListPage,
                  builder: (context, state) =>
                      PlayListPage(playlist: state.extra as Playlist),
                ),
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: Routes.uploadPage,
              builder: (context, state) => AudioUploadPage(),
            ),
          ]),
        ],
      ),
      GoRoute(
        path: Routes.authCheckPage,
        builder: (context, state) => AuthCheckPage(),
      ),
      GoRoute(
        path: Routes.createPlaylistPage,
        builder: (context, state) => CreatePlayList(),
      ),
      GoRoute(
        path: Routes.signInPage,
        builder: (context, state) => SignInPage(),
      ),
      GoRoute(
        path: Routes.signUpPage,
        builder: (context, state) => SignUpPage(),
      ),
    ]);
