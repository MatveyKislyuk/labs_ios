import 'package:get_it/get_it.dart';
import 'package:labs_ios/data/repositories/category_repository_impl.dart';
import 'package:labs_ios/data/repositories/task_repository_impl.dart';
import 'package:labs_ios/domain/repositories/category_repository.dart';
import 'package:labs_ios/domain/repositories/task_repository.dart';
import 'package:labs_ios/domain/usecases/add_category.dart';
import 'package:labs_ios/domain/usecases/add_task.dart';
import 'package:labs_ios/domain/usecases/delete_category.dart';
import 'package:labs_ios/domain/usecases/delete_task.dart';
import 'package:labs_ios/domain/usecases/get_categories.dart';
import 'package:labs_ios/domain/usecases/get_tasks.dart';
import 'package:labs_ios/data/datasources/category_local_data_source.dart';
import 'package:labs_ios/data/datasources/task_local_data_source.dart';
import 'package:labs_ios/domain/usecases/update_category.dart';
import 'package:labs_ios/domain/usecases/update_task.dart';
import 'package:labs_ios/presentation/cubits/category_cubit.dart';
import 'package:labs_ios/presentation/cubits/task_cubit.dart';
import 'package:labs_ios/data/database/database.dart';

final sl = GetIt.instance;

void init() {
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());


  sl.registerLazySingleton<CategoryLocalDataSource>(() => CategoryLocalDataSource(sl()));
  sl.registerLazySingleton<TaskLocalDataSource>(() => TaskLocalDataSource(sl()));


  sl.registerLazySingleton<CategoryRepository>(() => CategoryRepositoryImpl(sl()));
  sl.registerLazySingleton<TaskRepository>(() => TaskRepositoryImpl(sl()));


  sl.registerLazySingleton(() => AddCategory(sl()));
  sl.registerLazySingleton(() => AddTask(sl()));
  sl.registerLazySingleton(() => DeleteCategory(sl()));
  sl.registerLazySingleton(() => DeleteTask(sl()));
  sl.registerLazySingleton(() => GetCategories(sl()));
  sl.registerLazySingleton(() => GetTasks(sl()));
  sl.registerLazySingleton(() => UpdateTask(sl()));
  sl.registerLazySingleton(() => UpdateCategory(sl()));

  // Blocs
  sl.registerFactory(() => CategoryCubit(
    getCategories: sl(),
    addCategory: sl(),
    deleteCategory: sl(),
    updateCategory: sl(),
  ));

  sl.registerFactory(() => TaskCubit(
    getTasks: sl(),
    addTask: sl(),
    updateTask: sl(),
    deleteTask: sl(),
  ));
}