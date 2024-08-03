import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:marshal/Api/get_image_url.dart';
import 'package:marshal/Api/get_song_url.dart';
import 'package:marshal/data/models/song_model.dart';
import 'package:marshal/domain/repository/repository.dart';
import 'package:marshal/domain/repository/shared_song_repo.dart';

class SongRepoImpl implements SongRepo {
  @override
  Future<Option> getNewReleseas() async {
    final db = FirebaseFirestore.instance;
    final collection = db.collection('songs');
    final songsQuery = await collection
        .limit(5)
        .where('songId', isLessThanOrEqualTo: "00005")
        .get();
    if (songsQuery.docs.isNotEmpty) {
      List<Song> songs =
          songsQuery.docs.map((song) => Song.fromDocument(song)).toList();
      return Some(songs);
    } else {
      return none();
    }
  }

  @override
  Future<List<String>> generateSongUrls(SharedSongRepo sharedSongRepo) async {
    List<Song> listOfSongs = sharedSongRepo.getSongList();
    List<Future<String>> futures = List.generate(
      listOfSongs.length,
      (index) => getSongUrl(listOfSongs[index].songId + listOfSongs[index].ext),
    );
    List<String> urlList = await Future.wait(futures);
    return urlList;
  }

  @override
  AudioSource addSongstoPlayList(
      {required String url,
      required String coverUrl,
      required Song song,
      required SharedSongRepo sharedSongRepo}) {
    sharedSongRepo.currentlyPlayingSongList.add(song);

    AudioSource sourceses = AudioSource.uri(Uri.parse(url),
        tag: MediaItem(
          id: '0',
          title: song.name,
          artUri: Uri.parse(coverUrl),
        ));
    return sourceses;
  }

  @override
  Future<List<String>> generateCoverUrls(SharedSongRepo sharedSongrepo) async {
    List<Song> listOfSongs = sharedSongrepo.newReleaseList;
    List<Future<String>> futures = List.generate(
      listOfSongs.length,
      (index) => getCoverUrl(listOfSongs[index].coverId),
    );
    List<String> urlList = await Future.wait(futures);
    return urlList;
  }
}
