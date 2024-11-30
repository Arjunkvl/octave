part of 'category_cubit.dart';

class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

final class CategoryLoading extends CategoryState {}

final class CategoryLoaded extends CategoryState {
  final List<Category> category;

  const CategoryLoaded({required this.category});
  @override
  List<Object> get props => [category];
}

final class CategoryErrorState extends CategoryState {}
