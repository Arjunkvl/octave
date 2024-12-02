import 'dart:convert';

import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:marshal/Api/SpotifyApiModel/api_model.dart';
import 'package:marshal/data/models/song_model.dart';

import '../../../keys/spotify_keys.dart';

class SpotifyService {
  Future<void> fetchSpotifyApiToken() async {
    final String credentials =
        base64Encode(utf8.encode('$clientId:$clientSecret'));
    const String tokenUrl = 'https://accounts.spotify.com/api/token';
    try {
      final response = await http.post(
        Uri.parse(tokenUrl),
        headers: {
          'Authorization': 'Basic $credentials',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {'grant_type': 'client_credentials'},
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final box = await Hive.openBox('api');
        box.put(
            0,
            SpotifyApiModel(
              api: responseData['access_token'],
              expairesAt: DateTime.now()
                  .add(Duration(seconds: responseData['expires_in'])),
            ));
      }
    } catch (e) {
      return;
    }
  }

  Future<List<Song>> search({required String query}) async {
    List<Song> listOfReslt = [];
    final Box box = await Hive.openBox('api');
    final SpotifyApiModel api = box.getAt(0);
    final header = {'Authorization': 'Bearer ${api.api}'};
    final String endPoint =
        'https://api.spotify.com/v1/search?q=$query%&limit=10&type=track';
    final http.Response response =
        await http.get(Uri.parse(endPoint), headers: header);
    if (response.statusCode == 200) {
      listOfReslt = [];
      final jsonObject = jsonDecode(response.body);
      for (var item in jsonObject['tracks']['items']) {
        listOfReslt.add(Song(
            uploadedAt: DateTime.now(),
            artist: item['artists'][0]['name'],
            songId: item['id'],
            songUrl: '',
            title: item['name'],
            coverUrl: item['album']['images'][1]['url'],
            fileHash: item['id']));
      }
    }

    return listOfReslt;
  }
}
