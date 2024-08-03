part of 'home_page_bloc.dart';

abstract class HomePageEvent extends Equatable {
  const HomePageEvent();

  @override
  List<Object> get props => [];
}

class GetRequiredData extends HomePageEvent {}

class DataAccuredEvent extends HomePageEvent {}
