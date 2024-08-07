import 'package:flutter/material.dart';
import 'package:labs_ios/domain/entities/task.dart';
import 'package:labs_ios/presentation/cubits/task_cubit.dart';
import 'package:labs_ios/presentation/screens/task_detail_screen.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final TaskCubit taskCubit;
  final VoidCallback onDelete;
  final VoidCallback onToggleFavorite;
  final VoidCallback onToggleCompletion;
  final Function(Task) onUpdate;

  const TaskCard({
    Key? key,
    required this.task,
    required this.taskCubit,
    required this.onDelete,
    required this.onToggleFavorite,
    required this.onToggleCompletion,
    required this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      background: Container(
        color: Colors.green,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(
          Icons.check,
          color: Colors.white,
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(left: 20.0),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          onDelete();
        }
      },
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskDetailScreen(
                task: task,
                onUpdate: onUpdate,
                onDelete: (deletedTask) {
                  onDelete();
                  Navigator.pop(context);
                },
                taskCubit: taskCubit,
              ),
            ),
          );
        },
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Checkbox(
                value: task.isCompleted,
                onChanged: (newValue) {
                  onToggleCompletion();
                  taskCubit.modifyTask(task.copyWith(isCompleted: !task.isCompleted));
                },
              ),
              Text(task.title),
              IconButton(
                icon: Icon(
                  task.isFavourite ? Icons.star : Icons.star_outline,
                  color: task.isFavourite ? Colors.yellow : Colors.grey,
                ),
                onPressed: () {
                  onToggleFavorite();
                  taskCubit.modifyTask(task.copyWith(isFavourite: !task.isFavourite));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
