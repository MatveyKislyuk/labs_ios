import 'package:bloc/bloc.dart';
import 'package:labs_ios/domain/usecases/add_category.dart';
import 'package:labs_ios/domain/usecases/delete_category.dart';
import 'package:labs_ios/domain/usecases/get_categories.dart';
import 'package:labs_ios/domain/usecases/update_category.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategories getCategories;
  final AddCategory addCategory;
  final DeleteCategory deleteCategory;
  final UpdateCategory updateCategory;

  CategoryBloc({
    required this.getCategories,
    required this.addCategory,
    required this.deleteCategory,
    required this.updateCategory,
  }) : super(CategoryInitial()) {
    on<LoadCategories>((event, emit) async {
      emit(CategoryLoading());
      try {
        final categories = await getCategories();
        emit(CategoryLoaded(categories));
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    });

    on<AddNewCategory>((event, emit) async {
      await addCategory(event.category);
      add(LoadCategories());
    });

    on<DeleteCategoryEvent>((event, emit) async {
      await deleteCategory(event.id);
      add(LoadCategories());
    });

    on<UpdateCategoryEvent>((event, emit) async {
      await updateCategory(event.category);
      add(LoadCategories());
    });
  }
}