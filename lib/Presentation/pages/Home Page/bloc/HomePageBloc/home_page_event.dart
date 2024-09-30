part of 'home_page_bloc.dart';

abstract class HomePageEvent extends Equatable {
  const HomePageEvent();

  @override
  List<Object> get props => [];
}

class GetRequiredData extends HomePageEvent {
  final String lastSong;
  GetRequiredData({required this.lastSong});
  @override
  List<Object> get props => [lastSong];
}

class DataAccuredEvent extends HomePageEvent {}

class FetchDataEvent extends HomePageEvent {
  final DocumentSnapshot? lastItem;
  FetchDataEvent({this.lastItem});
}
