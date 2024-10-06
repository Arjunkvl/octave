import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marshal/Presentation/pages/Playing%20page/helpers/change_notifier.dart';
import 'package:marshal/application/dependency_injection.dart';
import 'package:marshal/data/models/song_model.dart';
import 'package:marshal/data/repository/song_repo_impl.dart';
import 'package:marshal/domain/Usecases/audio%20manage%20usecases/audio_usecases.dart';
import 'package:marshal/domain/Usecases/usecases.dart';
import 'package:marshal/domain/entities/Player%20Details%20Entity/player_details_entitiy.dart';
import 'package:marshal/domain/repository/shared_song_repo.dart';

part 'playing_page_event.dart';
part 'playing_page_state.dart';

class PlayingPageBloc extends Bloc<PlayingPageEvent, PlayingPageState> {
  final repository = SongRepoImpl();
  final SharedSongRepo sharedSongRepo;
  List<Song> currentlyPlayingSongs = [];
  final player = AudioPlayer();
  PlayingPageBloc({required this.sharedSongRepo})
      : super(PlayingPageInitial()) {
    player.setLoopMode(LoopMode.all);
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
      },
    );
    on<AddSongsEvent>((event, emit) async {
      final Box<Song> box = await Hive.openBox('songsBox');
      final List<Song> randomList = box.values.toList();
      randomList.shuffle();
      sharedSongRepo.currentlyPlayingSongList.addAll(randomList.take(10));

      final List<AudioSource> sources = await locator<AddSongstoPlayList>()
          .call(
              songs: sharedSongRepo.currentlyPlayingSongList,
              sharedSongRepo: sharedSongRepo);

      await playList.addAll(sources);
      if (player.currentIndex == null) {
        player.setPreferredPeakBitRate(100);
        player.setAudioSource(playList);
      }
    });
    on<LoadSongEvent>((event, emit) async {
      log(player.currentIndex.toString());
      if (!sharedSongRepo.currentlyPlayingSongList.contains(event.song)) {
        final Box<Song> box = await Hive.openBox('songsBox');
        if (!box.values.contains(event.song)) {
          await box.add(event.song);
        }
        sharedSongRepo.currentlyPlayingSongList.add(event.song);
        await player.pause();
        await playList.addAll(await locator<AddSongstoPlayList>()
            .call(songs: [event.song], sharedSongRepo: sharedSongRepo));
        await player.seek(Duration.zero,
            index: sharedSongRepo.currentlyPlayingSongList.indexOf(event.song));
        await locator<UploadToRecentSongs>().call(songId: event.song.songId);
        await player.play();
      }

      if (sharedSongRepo.currentlyPlayingSongList[player.currentIndex!] !=
          event.song) {
        await player.pause();
        await player.seek(Duration.zero,
            index: sharedSongRepo.currentlyPlayingSongList.indexOf(event.song));
        await player.play();
      } else {
        await player.play();
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

    on<SeekEvent>((event, emit) async {
      await player.seek(event.progress);
    });
  }

  @override
  Future<void> close() {
    player.dispose();
    return super.close();
  }
}
