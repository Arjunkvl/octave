part of 'home_page_bloc.dart';

abstract class HomePageState extends Equatable {
  const HomePageState();

  @override
  List<Object> get props => [];
}

class HomePageLoading extends HomePageState {}

class HomePageError extends HomePageState {}

@JsonSerializable()
class HomePageLoaded extends HomePageState {
  final List<Song> songs;
  final List<String> coverUrlList;

  HomePageLoaded({required this.coverUrlList, required this.songs});
  @override
  List<Object> get props => [songs, coverUrlList];
}
