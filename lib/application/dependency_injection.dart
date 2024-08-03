import 'package:get_it/get_it.dart';
import 'package:marshal/Presentation/pages/Home%20Page/bloc/HomePageBloc/home_page_bloc.dart';
import 'package:marshal/Presentation/pages/Playing%20page/bloc/PlayingPageBloc/playing_page_bloc.dart';
import 'package:marshal/data/repository/song_repo_impl.dart';
import 'package:marshal/domain/Usecases/usecases.dart';
import 'package:marshal/domain/repository/shared_song_repo.dart';
import 'package:marshal/domain/repository/shared_url_repo.dart';

GetIt locator = GetIt.instance;

void setUpLocator() {
  SharedSongRepo sharedSongRepo = SharedSongRepo();
  SharedUrlRepo sharedUrlRepo = SharedUrlRepo();
  SongRepoImpl repository = SongRepoImpl();

  //HomePage Bloc Injection
  locator.registerSingleton<HomePageBloc>(HomePageBloc(
      sharedSongRepo: sharedSongRepo, sharedUrlRepo: sharedUrlRepo));
  //playing page Bloc Injection
  locator.registerSingleton<PlayingPageBloc>(PlayingPageBloc(
      sharedSongRepo: sharedSongRepo, sharedUrlRepo: sharedUrlRepo));

  //Usecases;
  locator.registerSingleton<GetNewReleseas>(
      GetNewReleseas(repository: repository));
  locator.registerSingleton<GenerateSongUrls>(
      GenerateSongUrls(repository: repository));
  locator.registerSingleton<AddSongstoPlayList>(
      AddSongstoPlayList(repository: repository));
  locator.registerSingleton<GenerateCoverUrls>(
      GenerateCoverUrls(repository: repository));
}
