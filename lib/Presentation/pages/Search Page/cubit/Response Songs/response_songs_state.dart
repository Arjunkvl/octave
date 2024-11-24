part of 'response_songs_cubit.dart';

class ResponseSongsState extends Equatable {
  const ResponseSongsState();

  @override
  List<Object> get props => [];
}

final class ResponseSongsInitial extends ResponseSongsState {}

final class ShowResultState extends ResponseSongsState {
  final List<Song> listOfSongs;
  ShowResultState({required this.listOfSongs});
  @override
  List<Object> get props => [listOfSongs];
}
