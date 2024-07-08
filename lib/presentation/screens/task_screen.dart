import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:labs_ios/domain/entities/category.dart';
import 'package:labs_ios/domain/entities/task.dart';
import 'package:labs_ios/domain/entities/task_filter.dart';
import 'package:labs_ios/presentation/blocs/task_bloc.dart';
import 'package:labs_ios/presentation/widgets/task_card.dart';
import 'package:uuid/uuid.dart';

import '../blocs/task_event.dart';
import '../blocs/task_state.dart';

class TasksScreen extends StatefulWidget {
  final Category category;

  const TasksScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  TaskFilter currentFilter = TaskFilter.All;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<TaskBloc>()..add(LoadTasks(widget.category.id)),
      child: Scaffold(
        appBar: AppBar(
          elevation: 4.0,
          toolbarHeight: 120.0,
          backgroundColor: Colors.blueAccent,
          title: Text(widget.category.name),
          actions: [
            PopupMenuButton<TaskFilter>(
              onSelected: (TaskFilter value) {
                setState(() {
                  currentFilter = value;
                  context.read<TaskBloc>().add(LoadTasks(widget.category.id));
                });
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
            )
          ],
        ),
        body: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state is TaskLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TaskLoaded) {
              List<Task> filteredTasks;
              switch (currentFilter) {
                case TaskFilter.Completed:
                  filteredTasks = state.tasks.where((task) => task.isCompleted).toList();
                  break;
                case TaskFilter.Uncompleted:
                  filteredTasks = state.tasks.where((task) => !task.isCompleted).toList();
                  break;
                case TaskFilter.Favorites:
                  filteredTasks = state.tasks.where((task) => task.isFavourite).toList();
                  break;
                case TaskFilter.All:
                default:
                  filteredTasks = state.tasks;
                  break;
              }

              return filteredTasks.isNotEmpty
                  ? ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = filteredTasks[index];
                  return TaskCard(
                    task: task,
                    onDelete: () {
                      context.read<TaskBloc>().add(DeleteTaskEvent(task.id));
                    },
                    onToggleCompletion: () {
                      task.isCompleted = !task.isCompleted;
                      context.read<TaskBloc>().add(UpdateTaskEvent(task));
                    },
                    onToggleFavorite: () {
                      task.isFavourite = !task.isFavourite;
                      context.read<TaskBloc>().add(UpdateTaskEvent(task));
                    },
                    onUpdate: (updatedTask) {
                      context.read<TaskBloc>().add(UpdateTaskEvent(updatedTask));
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
                  context.read<TaskBloc>().add(AddNewTask(newTask));
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