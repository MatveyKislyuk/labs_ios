import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labs_ios/presentation/cubits/category_cubit.dart';
import 'package:labs_ios/presentation/widgets/category_card.dart';
import 'package:labs_ios/domain/entities/category.dart';
import 'package:uuid/uuid.dart';
import 'package:labs_ios/presentation/cubits/category_state.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4.0,
        toolbarHeight: 120.0,
        backgroundColor: Colors.blueAccent,
        flexibleSpace: FlexibleSpaceBar(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text(
              'Категории задач',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          centerTitle: true,
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state.status == CategoryStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == CategoryStatus.loaded) {
            return state.categories.isNotEmpty
                ? ListView.builder(
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final category = state.categories[index];
                return CategoryCard(
                  category: category,
                  onDismissed: () {
                    context.read<CategoryCubit>().deleteCategoryById(category.id);
                  },
                  onEdit: (newName) {
                    final updatedCategory = Category(
                      id: category.id,
                      name: newName,
                      createdAt: category.createdAt,
                    );
                    context.read<CategoryCubit>().modifyCategory(updatedCategory);
                  },
                );
              },
            )
                : const Center(child: Text('Список категорий пуст'));
          } else if (state.status == CategoryStatus.error) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Неизвестная ошибка'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewCategory(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addNewCategory(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController nameController = TextEditingController();
        return AlertDialog(
          title: const Text('Добавить категорию'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: 'Название категории',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  final newCategory = Category(
                    id: const Uuid().v4(),
                    name: name,
                    createdAt: DateTime.now(),
                  );
                  context.read<CategoryCubit>().addNewCategory(newCategory);
                }
                Navigator.pop(context);
              },
              child: const Text('Добавить'),
            ),
          ],
        );
      },
    );
  }
}