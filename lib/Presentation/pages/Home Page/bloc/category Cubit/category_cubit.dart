import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:marshal/application/dependency_injection.dart';
import 'package:marshal/data/models/Category%20model/category_model.dart';
import 'package:marshal/domain/Usecases/usecases.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryLoading());
  Future<void> fetchCategories() async {
    List<Category> list = [];
    emit(CategoryLoading());
    if (list.isEmpty) {
      Option<List<Category>> result = await locator<GetCategories>().call();
      result.fold(() => emit(CategoryErrorState()), (categorys) async {
        list = categorys;
      });
    }
    emit(CategoryLoaded(category: list));
  }
}
