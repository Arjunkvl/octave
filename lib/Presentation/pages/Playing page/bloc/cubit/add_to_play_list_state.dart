part of 'add_to_play_list_cubit.dart';

sealed class AddToPlayListState extends Equatable {
  const AddToPlayListState();

  @override
  List<Object> get props => [];
}

final class AddToPlayListInitial extends AddToPlayListState {}

class ShowChoosePlayListPage extends AddToPlayListState {
  final List<Playlist> playlist;
  const ShowChoosePlayListPage({required this.playlist});
}
