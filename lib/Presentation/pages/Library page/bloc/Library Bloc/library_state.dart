part of 'library_bloc.dart';

abstract class LibraryState extends Equatable {
  const LibraryState();

  @override
  List<Object> get props => [];
}

class LibraryLoading extends LibraryState {}

class LibraryLoaded extends LibraryState {
  final List<Playlist> playLists;
  const LibraryLoaded({required this.playLists});
  @override
  List<Object> get props => [playLists];
}
