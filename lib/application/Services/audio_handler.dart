import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marshal/Presentation/pages/Playing%20page/bloc/PlayingPageBloc/playing_page_bloc.dart';
import 'package:marshal/application/Services/Youtube/youtube_api.dart';
import 'package:marshal/application/dependency_injection.dart';
import 'package:marshal/core/recently_playing_list.dart';

Future<AudioHandler> initAudioService() async {
  return await AudioService.init(
    builder: () => CustmAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
}

class CustmAudioHandler extends BaseAudioHandler with SeekHandler {
  final _player = AudioPlayer();

  final _playlist = ConcatenatingAudioSource(children: []);
  CustmAudioHandler() {
    _loadEmptyPlayList();
    _notifyAudioHandlerAboutPlaybackEvents();
    _listenForDurationChanges();
  }
  Future<void> _loadEmptyPlayList() async {
    await _player.setLoopMode(LoopMode.all);
    await _player.setAudioSource(_playlist);
  }

  Future<void> setLoopMode(LoopMode loopMode) async {
    switch (loopMode) {
      case LoopMode.all:
        _player.setLoopMode(LoopMode.all);
      case LoopMode.one:
        _player.setLoopMode(LoopMode.one);
      default:
        _player.setLoopMode(LoopMode.all);
    }
  }

  Future<void> startFreshQueue() async {
    await _playlist.clear();
    queue.add([]);
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    List<Future<AudioSource>> futureAudioSources = mediaItems.map((item) {
      return _createAudioSource(item); // returns a Future<AudioSource>
    }).toList();

    // Wait for all futures to complete and return the list of results
    final audioSource = await Future.wait(futureAudioSources);

    await _playlist.addAll(audioSource.toList());

    // notify system
    final newQueue = List<MediaItem>.from(queue.value);
    newQueue.addAll(mediaItems);
    queue.add(newQueue);
    mediaItem.add(mediaItems[0]);
  }

  Future<LockCachingAudioSource> _createAudioSource(MediaItem mediaItem) async {
    return LockCachingAudioSource(
      Uri.parse(
        mediaItem.extras!['songUrl'] == '' ||
                mediaItem.extras!['songUrl'].contains('googlevideo')
            ? await YoutubeApiServices().getAudioOnlyLink(
                artist: mediaItem.artist!, title: mediaItem.title)
            : mediaItem.extras!['songUrl'],
      ),
      tag: mediaItem,
    );
  }

  void _listenForDurationChanges() {
    _player.durationStream.listen((duration) {
      final index = _player.currentIndex;
      final newQueue = queue.value;
      if (index == null || newQueue.isEmpty) return;
      final oldMediaItem = newQueue[index];
      final newMediaItem = oldMediaItem.copyWith(duration: duration);
      newQueue[index] = newMediaItem;
      queue.add(newQueue);
      mediaItem.add(newMediaItem);
      if (playingSongList.isNotEmpty) {
        locator<PlayingPageBloc>().add(UpdatePlayingPageEvent(
            song: playingSongList[_player.currentIndex!]));
      }
    });
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _player.playbackEventStream.listen((PlaybackEvent event) {
      final playing = _player.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          // MediaControl.skipToPrevious,
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
          // MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
        },
        androidCompactActionIndices: const [0, 1, 3],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        playing: playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: event.currentIndex,
      ));
    });
  }

  @override
  Future<void> play() async {
    playbackState.add(playbackState.value
        .copyWith(playing: true, controls: [MediaControl.pause]));
    await _player.play();
  }

  @override
  Future<void> pause() async {
    playbackState.add(playbackState.value
        .copyWith(playing: false, controls: [MediaControl.play]));
    await _player.pause();
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    if (_playlist.length != -1) {
      mediaItem.add(queue.value[index]);
      await _player.seek(Duration.zero, index: index);
    }
  }

  @override
  Future<void> seek(Duration position) async => await _player.seek(position);

  @override
  Future<void> skipToNext() async {
    if (_player.hasNext &&
        queue.stream.value.length != _player.currentIndex! + 1) {
      await _player.seek(Duration.zero, index: _player.currentIndex! + 1);
    }
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    return super.stop();
  }

  @override
  Future<void> skipToPrevious() async {
    await _player.seekToPrevious();
  }
}
