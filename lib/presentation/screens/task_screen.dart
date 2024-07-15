import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labs_ios/domain/entities/category.dart';
import 'package:labs_ios/domain/entities/task.dart';
import 'package:labs_ios/presentation/cubits/task_cubit.dart';
import 'package:labs_ios/presentation/widgets/task_card.dart';
import 'package:uuid/uuid.dart';
import 'package:labs_ios/presentation/cubits/task_state.dart';

class TasksScreen extends StatefulWidget {
  final Category category;

  const TasksScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TaskCubit>().loadTasks(widget.category.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4.0,
        toolbarHeight: 120.0,
        backgroundColor: Colors.blueAccent,
        title: Text(widget.category.name),
        actions: [
          BlocBuilder<TaskCubit, TaskState>(
            builder: (context, state) {
              if (state is TaskLoaded) {
                return PopupMenuButton<TaskFilter>(
                  initialValue: context.read<TaskCubit>().currentFilter,
                  onSelected: (TaskFilter value) {
                    context.read<TaskCubit>().filterTasks(state.tasks, value);
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: TaskFilter.All,
                      child: Text('Все'),
                    ),
                    const PopupMenuItem(
                      value: TaskFilter.Completed,
                      child: Text('Завершенные'),
                    ),
                    const PopupMenuItem(
                      value: TaskFilter.Uncompleted,
                      child: Text('Незавершенные'),
                    ),
                    const PopupMenuItem(
                      value: TaskFilter.Favorites,
                      child: Text('Избранные'),
                    ),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          )
        ],
      ),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TaskLoaded) {
            List<Task> tasks = state.tasks;
            return tasks.isNotEmpty
                ? ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskCard(
                  task: task,
                  taskCubit: context.read<TaskCubit>(),
                  onDelete: () {
                    context.read<TaskCubit>().deleteTaskById(task.id);
                  },
                  onToggleCompletion: () {
                    context.read<TaskCubit>().modifyTask(task.copyWith(isCompleted: !task.isCompleted));
                  },
                  onToggleFavorite: () {
                    context.read<TaskCubit>().modifyTask(task.copyWith(isFavourite: !task.isFavourite));
                  },
                  onUpdate: (updatedTask) {
                    context.read<TaskCubit>().modifyTask(updatedTask);
                  },
                );
              },
            )
                : const Center(child: Text('Список задач пуст'));
          } else if (state is TaskError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Неизвестная ошибка'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewTask(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addNewTask(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController titleController = TextEditingController();
        final TextEditingController descriptionController = TextEditingController();
        return AlertDialog(
          title: const Text('Добавить задачу'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Название задачи',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Описание задачи (необязательно)',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                final title = titleController.text.trim();
                final description = descriptionController.text.trim();
                if (title.isNotEmpty) {
                  final newTask = Task(
                    id: const Uuid().v4(),
                    title: title,
                    description: description.isEmpty ? null : description,
                    isCompleted: false,
                    isFavourite: false,
                    categoryId: widget.category.id,
                    createdAt: DateTime.now(),
                  );
                  context.read<TaskCubit>().addNewTask(newTask);
                  Navigator.pop(context);
                }
              },
              child: const Text('Добавить'),
            ),
          ],
        );
      },
    );
  }
}
