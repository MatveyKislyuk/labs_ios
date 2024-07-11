import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labs_ios/core/utils/service_locator.dart';
import 'package:labs_ios/presentation/screens/categories_screen.dart';
import 'package:labs_ios/presentation/cubits/category_cubit.dart';
import 'package:labs_ios/presentation/cubits/task_cubit.dart';
import 'package:get_it/get_it.dart';

void main() {
  init();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CategoryCubit>(
          create: (context) => GetIt.I<CategoryCubit>()..loadCategories(),
        ),
        BlocProvider<TaskCubit>(
          create: (context) => GetIt.I<TaskCubit>(),
        ),
      ],
      child: const MaterialApp(
        home: CategoriesScreen(),
      ),
    );
  }
}