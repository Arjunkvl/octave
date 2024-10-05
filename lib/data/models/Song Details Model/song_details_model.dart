class SongDetailsModel {
  final String album;
  final String genre;
  final int playCount;
  final int likeCount;
  final String releaseYear;
  final String language;

  SongDetailsModel({
    required this.album,
    required this.genre,
    required this.playCount,
    required this.likeCount,
    required this.releaseYear,
    required this.language,
  });

  Map<String, dynamic> toMap() {
    return {
      'album': album,
      'genre': genre,
      'playCount': playCount,
      'likeCount': likeCount,
      'releaseYear': releaseYear,
      'language': language,
    };
  }
}
