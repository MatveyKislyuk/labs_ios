import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';  // Убедись, что этот импорт есть
import 'package:labs_ios/domain/entities/task.dart';
import 'package:labs_ios/presentation/cubits/task_cubit.dart';
import 'package:labs_ios/presentation/cubits/task_state.dart';  // Добавь этот импорт

class TaskDetailScreen extends StatefulWidget {
  final Task task;
  final Function(Task) onUpdate;
  final Function(Task) onDelete;
  final TaskCubit taskCubit;

  const TaskDetailScreen({
    Key? key,
    required this.task,
    required this.onUpdate,
    required this.onDelete,
    required this.taskCubit,
  }) : super(key: key);

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;


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
              'Задачи для ${widget.task.title}',
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
      body: Column(
        children: [
          Container(
            color: Colors.blue[700],
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const SizedBox(width: 8),
                Text(
                  'Создана: ${widget.task.createdAt}',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Название',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Описание',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                if (widget.task.imageUrl != null) ...[
                  Image.network(widget.task.imageUrl!),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      widget.taskCubit.selectImage('');  // Устанавливаем изображение как пустую строку
                      setState(() {
                        widget.task.imageUrl = null;
                      });
                    },
                  ),
                ],
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  ),
                  onPressed: () {
                    widget.taskCubit.modifyTask(
                      widget.task.copyWith(
                        title: _titleController.text,
                        description: _descriptionController.text,
                      ),
                    );
                    widget.onUpdate(widget.task);
                    Navigator.pop(context);
                  },
                  child: const Text('Сохранить'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    backgroundColor: Colors.red[300],
                  ),
                  onPressed: () {
                    widget.onDelete(widget.task);
                    Navigator.pop(context);
                  },
                  child: const Text('Удалить'),
                ),
                const SizedBox(height: 16),
                BlocBuilder<TaskCubit, TaskState>(
                  bloc: widget.taskCubit,
                  builder: (context, state) {
                    if (state is TaskImagesLoaded) {
                      return Column(
                        children: [
                          GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1,
                            ),
                            itemCount: state.images.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  widget.taskCubit.selectImage(state.images[index]);
                                },
                                child: Image.network(state.images[index]),
                              );
                            },
                          ),
                          TextButton(
                            onPressed: () {
                              widget.taskCubit.fetchMoreImages('nature');
                            },
                            child: const Text('Загрузить ещё'),
                          ),
                        ],
                      );
                    }
                    return Center(child: Text('Нет изображений'));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
