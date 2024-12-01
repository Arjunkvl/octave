part of 'library_bloc.dart';

abstract class LibraryEvent extends Equatable {
  const LibraryEvent();

  @override
  List<Object> get props => [];
}

class GetPlayListsEvent extends LibraryEvent {}

class AddPlayListEvent extends LibraryEvent {
  final Playlist playlist;
  const AddPlayListEvent({required this.playlist});
}

class RemovePlayListEvent extends LibraryEvent {
  final String title;
  const RemovePlayListEvent({required this.title});
}
