import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:marshal/Presentation/pages/Main%20Home%20Page/bloc/Player%20Controller%20Cubit/player_controller_cubit.dart';
import 'package:marshal/Presentation/pages/Playing%20page/bloc/PlayingPageBloc/playing_page_bloc.dart';
import 'package:marshal/application/Services/audio_handler.dart';
import 'package:marshal/application/authRepo/auth_repo.dart';
import 'package:marshal/application/authUsecases/auth_usecases.dart';
import 'package:marshal/data/repository/Audio%20Manage%20Repo/audio_manage_impl.dart';
import 'package:marshal/data/repository/User%20SetUp%20Repo/user_setup_repo_impl.dart';
import 'package:marshal/data/repository/song_repo_impl.dart';
import 'package:marshal/domain/Usecases/User%20SetUp%20Usecases/user_setup_usecases.dart';
import 'package:marshal/domain/Usecases/audio%20manage%20usecases/audio_usecases.dart';
import 'package:marshal/domain/Usecases/usecases.dart';

GetIt locator = GetIt.instance;

Future<void> setUpLocator() async {
  // SharedSongRepo sharedSongRepo = SharedSongRepo();

  SongRepoImpl repository = SongRepoImpl();
  UserSetupRepoImpl userSetUpRepo = UserSetupRepoImpl();
  AuthRepo authRepo = AuthRepo();
  AudioManageImpl audioManageRepo = AudioManageImpl();
  locator.registerSingleton<AudioHandler>(await initAudioService());
  //This is for playingPage component cubit

  //This is for PlayerController cubit
  locator.registerSingleton<PlayerControllerCubit>(PlayerControllerCubit());
  locator.registerSingleton<PlayingPageBloc>(PlayingPageBloc());
  //Usecases;
  locator
      .registerSingleton<GetCategories>(GetCategories(repository: repository));
  locator.registerSingleton<GetSongFromSongIds>(
      GetSongFromSongIds(repository: audioManageRepo));
  locator.registerSingleton<GenerateFileHash>(
      GenerateFileHash(repository: audioManageRepo));

  locator.registerSingleton<GetAllSongsWithPagination>(
      GetAllSongsWithPagination(repository: repository));
  locator.registerSingleton<SetCloudSpace>(
      SetCloudSpace(repository: userSetUpRepo));
  locator.registerSingleton<AddPlayListToCloud>(
      AddPlayListToCloud(repository: userSetUpRepo));
  locator.registerSingleton<UpdatePlayList>(
      UpdatePlayList(repository: userSetUpRepo));
  locator.registerSingleton<RemovePlayListFromCloud>(
      RemovePlayListFromCloud(repository: userSetUpRepo));

  locator
      .registerSingleton<GetPlayLists>(GetPlayLists(repository: userSetUpRepo));
  locator
      .registerSingleton<GetUserSignedUp>(GetUserSignedUp(authRepo: authRepo));
  locator.registerSingleton<UserSignIn>(UserSignIn(authRepo: authRepo));

  // locator.registerSingleton<AuthStatusCheckingCubit>(
  //   AuthStatusCheckingCubit(SchedulerBinding.instance),
  // );
  locator.registerSingleton<ExtractAudioMetadata>(
      ExtractAudioMetadata(repository: audioManageRepo));
  locator
      .registerSingleton<UploadAudio>(UploadAudio(repository: audioManageRepo));
  locator.registerSingleton<UploadEssentials>(
      UploadEssentials(repository: audioManageRepo));
}
