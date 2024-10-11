import 'dart:developer' as l;
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marshal/Presentation/pages/Main%20Home%20Page/bloc/Player%20Controller%20Cubit/player_controller_cubit.dart';
import 'package:marshal/Presentation/pages/Playing%20page/bloc/Playing%20Page%20Components/playing_page_components_cubit.dart';
import 'package:marshal/Presentation/pages/Playing%20page/helpers/change_notifier.dart';
import 'package:marshal/application/dependency_injection.dart';
import 'package:marshal/data/models/song_model.dart';
import 'package:marshal/domain/Usecases/audio%20manage%20usecases/audio_usecases.dart';
import 'package:marshal/domain/Usecases/usecases.dart';
import 'package:marshal/domain/entities/Player%20Details%20Entity/player_details_entitiy.dart';
import 'package:marshal/domain/repository/shared_song_repo.dart';

part 'playing_page_event.dart';
part 'playing_page_state.dart';

class PlayingPageBloc extends Bloc<PlayingPageEvent, PlayingPageState> {
  final SharedSongRepo sharedSongRepo;
  final player = AudioPlayer();
  Duration position = Duration.zero;

  PlayingPageBloc({required this.sharedSongRepo})
      : super(PlayingPageInitial()) {
    player.setLoopMode(LoopMode.off);
    final playList = ConcatenatingAudioSource(
      useLazyPreparation: true,
      shuffleOrder: DefaultShuffleOrder(),
      children: [],
    );

    //streams listening to playing states;
    player.positionStream.listen(
      (event) {
        position = event;
        add(UpdatePlayerBarEvent(progress: event));
      },
    );
    player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed && position != Duration.zero) {
        add(AddRandomSongEvent(index: player.currentIndex!));
      }
    });
    player.playingStream.listen(
      (event) {
        isPlaying.value = event;
      },
    );
    on<AddRandomSongEvent>((event, emit) async {
      l.log('random song added');
      final Box<Song> box = await Hive.openBox('songsBox');
      final int index = Random().nextInt(box.length - 1);
      if (!sharedSongRepo.currentlyPlayingSongList
          .contains(box.values.toList()[index])) {
        await playList.addAll(await locator<AddSongstoPlayList>().call(
            songs: [box.values.toList()[index]],
            sharedSongRepo: sharedSongRepo));
      }
      await player.seekToNext();
      locator<PlayingPageComponentsCubit>()
          .setComponents(song: box.values.toList()[index]);
      locator<PlayerControllerCubit>()
          .showPlayerController(song: box.values.toList()[index]);
    });
    on<LoadSongEvent>((event, emit) async {
      locator<PlayingPageComponentsCubit>().setComponents(song: event.song);
      locator<PlayerControllerCubit>().showPlayerController(song: event.song);
      if (player.currentIndex == null) {
        await player.setPreferredPeakBitRate(100);
        await player.setAudioSource(playList);
      }

      if (!sharedSongRepo.currentlyPlayingSongList.contains(event.song)) {
        final Box<Song> box = await Hive.openBox('songsBox');
        if (!box.values.contains(event.song)) {
          await box.add(event.song);
        }
        await playList.addAll(await locator<AddSongstoPlayList>()
            .call(songs: [event.song], sharedSongRepo: sharedSongRepo));
        await player.seek(Duration.zero,
            index: sharedSongRepo.currentlyPlayingSongList.indexOf(event.song));
        await locator<UploadToRecentSongs>().call(songId: event.song.songId);
        if (!player.playing) await player.play();
      }

      if (sharedSongRepo.currentlyPlayingSongList[player.currentIndex!] !=
          event.song) {
        await player.seek(Duration.zero,
            index: sharedSongRepo.currentlyPlayingSongList.indexOf(event.song));
        if (!player.playing) await player.play();
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
      add(AddRandomSongEvent(index: player.currentIndex!));
    });
    on<SkipPreviousEvent>((event, emit) async {
      await player.seekToPrevious();
      locator<PlayingPageComponentsCubit>().setComponents(
          song: sharedSongRepo.currentlyPlayingSongList[player.currentIndex!]);
      locator<PlayerControllerCubit>().showPlayerController(
          song: sharedSongRepo.currentlyPlayingSongList[player.currentIndex!]);
    });
    on<UpdatePlayerBarEvent>((event, emit) {
      emit(UpdatedPlayerBar(
        playerDetailsEntitiy: PlayerDetailsEntitiy(
            totalDuration: player.duration ?? Duration.zero,
            progress: event.progress),
      ));
    });

    on<SeekEvent>((event, emit) async {
      await player.seek(event.progress);
    });
  }

  @override
  Future<void> close() async {
    await player.dispose();
    return super.close();
  }
}
