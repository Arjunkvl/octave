import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marshal/Presentation/pages/Playing%20page/helpers/animation_controller.dart';
import 'package:marshal/Presentation/pages/Playing%20page/helpers/change_notifier.dart';
import 'package:marshal/application/dependency_injection.dart';
import 'package:marshal/data/models/song_model.dart';
import 'package:marshal/data/repository/song_repo_impl.dart';
import 'package:marshal/domain/Usecases/usecases.dart';
import 'package:marshal/domain/entities/Player%20Details%20Entity/player_details_entitiy.dart';
import 'package:marshal/domain/repository/shared_song_repo.dart';
import 'package:marshal/domain/repository/shared_url_repo.dart';

part 'playing_page_event.dart';
part 'playing_page_state.dart';

class PlayingPageBloc extends Bloc<PlayingPageEvent, PlayingPageState> {
  final repository = SongRepoImpl();
  final SharedSongRepo sharedSongRepo;
  final SharedUrlRepo sharedUrlRepo;
  final player = AudioPlayer();
  PlayingPageBloc({required this.sharedUrlRepo, required this.sharedSongRepo})
      : super(PlayingPageInitial()) {
    final playList = ConcatenatingAudioSource(
      useLazyPreparation: true,
      shuffleOrder: DefaultShuffleOrder(),
      children: [],
    );

    //streams listening to playing states;
    player.positionStream.listen(
      (event) {
        add(UpdatePlayerBarEvent(progress: event));
      },
    );
    player.playingStream.listen(
      (event) {
        isPlaying.value = event;
        if (event) {
          animationController.reverse();
        } else {
          animationController.forward();
        }
      },
    );

    on<LoadSongEvent>((event, emit) async {
      log(player.currentIndex.toString());
      if (player.currentIndex == null) {
        player.setAudioSource(playList);
      }
      if (!sharedSongRepo.currentlyPlayingSongList.contains(event.song)) {
        playList.add(locator<AddSongstoPlayList>().call(
            url: sharedUrlRepo.songUrlList[event.index],
            coverUrl: sharedUrlRepo.coverUrlList[event.index],
            song: sharedSongRepo.newReleaseList[event.index],
            sharedSongRepo: sharedSongRepo));
        await player.play();
      }
      log(sharedSongRepo.currentlyPlayingSongList[player.currentIndex!]
          .toString());
      log(event.song.toString());
      if (sharedSongRepo.currentlyPlayingSongList[player.currentIndex!] !=
          event.song) {
        log('kk');
        player.seek(Duration.zero, index: 1);
      }
    });
    on<PlaySongEvent>((event, emit) async {
      await player.play();
      emit(
        UpdatedPlayerBar(
          playerDetailsEntitiy: PlayerDetailsEntitiy(
              progress: player.position, totalDuration: player.duration!),
        ),
      );
    });
    on<PauseSongEvent>((event, emit) async {
      await player.pause();
      emit(
        UpdatedPlayerBar(
          playerDetailsEntitiy: PlayerDetailsEntitiy(
              progress: player.position, totalDuration: player.duration!),
        ),
      );
    });

    //skip to Next Eveny adds new song to the playlist;
    on<SkipNextEvent>((event, emit) async {
      int index = event.index + 1;
      if (!player.hasNext) {
        playList.add(locator<AddSongstoPlayList>().call(
            url: sharedUrlRepo.songUrlList[index],
            coverUrl: sharedUrlRepo.coverUrlList[index],
            song: sharedSongRepo.newReleaseList[index],
            sharedSongRepo: sharedSongRepo));
        await player.seekToNext();
      }
      await player.seekToNext();
    });
    on<SkipPreviousEvent>((event, emit) async {
      await player.seekToPrevious();
    });
    on<UpdatePlayerBarEvent>((event, emit) {
      emit(UpdatedPlayerBar(
        playerDetailsEntitiy: PlayerDetailsEntitiy(
            totalDuration: player.duration ?? Duration.zero,
            progress: event.progress),
      ));
    });
  }

  @override
  Future<void> close() {
    player.dispose();
    return super.close();
  }
}
