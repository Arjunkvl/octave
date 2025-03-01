part of 'library_bloc.dart';

abstract class LibraryEvent extends Equatable {
  const LibraryEvent();

  @override
  List<Object> get props => [];
}

class GetPlayListsEvent extends LibraryEvent {}

class InitialEvent extends LibraryEvent {}

class PlayListToQueue extends LibraryEvent {
  final Playlist playlist;
  const PlayListToQueue({required this.playlist});
}

class AddPlayListEvent extends LibraryEvent {
  final Playlist playlist;
  const AddPlayListEvent({required this.playlist});
}

class RemoveFromPlayListEvent extends LibraryEvent {
  final int index;
  final Playlist playlist;
  const RemoveFromPlayListEvent({required this.index, required this.playlist});
}

class AddToPlayListEvent extends LibraryEvent {
  final Song song;
  final Playlist playlist;
  const AddToPlayListEvent({required this.song, required this.playlist});
}

class RemovePlayListEvent extends LibraryEvent {
  final String title;
  const RemovePlayListEvent({required this.title});
}
