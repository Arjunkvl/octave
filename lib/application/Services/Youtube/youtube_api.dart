import 'package:marshal/data/models/song_model.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class YoutubeApiServices {
  Future<String> getAudioOnlyLink({required Song song}) async {
    final String name = '${song.title} song ${song.artist}';
    final YoutubeExplode yt = YoutubeExplode();
    final response = await yt.search.search(name);
    final manifest = await yt.videos.streamsClient.getManifest(response[0].id);
    final audio = manifest.audioOnly;

    return audio.first.url.toString();
  }
}
