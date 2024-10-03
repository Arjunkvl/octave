part of 'home_page_bloc.dart';

abstract class HomePageState extends Equatable {
  const HomePageState();

  @override
  List<Object> get props => [];
}

class HomePageLoading extends HomePageState {}

class HomePageError extends HomePageState {}

class HomePageLoaded extends HomePageState {
  final List<Song> songs;

  HomePageLoaded({required this.songs});

  @override
  List<Object> get props => [songs];
}
