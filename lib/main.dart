import 'package:labs_ios/presentation/blocs/category_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labs_ios/core/utils/service_locator.dart';
import 'package:labs_ios/presentation/screens/categories_screen.dart';
import 'package:labs_ios/presentation/blocs/category_bloc.dart';
import 'package:labs_ios/presentation/blocs/task_bloc.dart';
import 'package:get_it/get_it.dart';

void main() {
  init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CategoryBloc>(
          create: (context) => GetIt.I<CategoryBloc>()..add(LoadCategories()),
        ),
        BlocProvider<TaskBloc>(
          create: (context) => GetIt.I<TaskBloc>(),
        ),
      ],
      child: MaterialApp(
        home: const CategoriesScreen(),
      ),
    );
  }
}