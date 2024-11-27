import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

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

class CustmAudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer();

  final _playlist = ConcatenatingAudioSource(children: []);
  CustmAudioHandler() {
    _loadEmptyPlayList();
    _notifyAudioHandlerAboutPlaybackEvents();
    _listenForDurationChanges();
  }
  Future<void> _loadEmptyPlayList() async {
    _player.setLoopMode(LoopMode.all);
    await _player.setAudioSource(_playlist);
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    // manage Just Audio
    final audioSource = mediaItems.map(_createAudioSource);

    await _playlist.addAll(audioSource.toList());

    // notify system
    final newQueue = queue.value..addAll(mediaItems);
    queue.add(newQueue);
    mediaItem.add(newQueue[0]);
  }

  LockCachingAudioSource _createAudioSource(MediaItem mediaItem) {
    return LockCachingAudioSource(
      Uri.parse(mediaItem.extras!['songUrl']),
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
    });
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    _player.playbackEventStream.listen((PlaybackEvent event) {
      final playing = _player.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          // MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          // MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.skipToNext,
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
    playbackState.add(playbackState.value.copyWith(playing: true, controls: [
      MediaControl.pause,
    ]));
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
    if (_player.hasNext) {
      await _player.seek(Duration.zero, index: _player.currentIndex! + 1);
      await _player.play();
    }
  }

  @override
  Future<void> skipToPrevious() async {
    await _player.seekToPrevious();
    await _player.play();
  }
}
