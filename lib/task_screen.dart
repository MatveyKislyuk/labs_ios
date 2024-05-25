import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_provider.dart';
import 'models.dart' as models;
import 'task_detail_screen.dart';

class TaskScreen extends StatefulWidget {
  final models.Category category;

  TaskScreen({required this.category});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    var taskProvider = Provider.of<TaskProvider>(context);
    var tasks = _getFilteredTasks(taskProvider);

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: FlexibleSpaceBar(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text(
              'Задачи для ${widget.category.name}',
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _selectedFilter,
              dropdownColor: Colors.blueAccent,
              items: [
                DropdownMenuItem(child: Text('Все'), value: 'All'),
                DropdownMenuItem(child: Text('Завершенные'), value: 'Completed'),
                DropdownMenuItem(child: Text('Незавершенные'), value: 'Incomplete'),
                DropdownMenuItem(child: Text('Избранные'), value: 'Favourite'),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value!;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                var task = tasks[index];
                return GestureDetector( // Обертываем ListTile в GestureDetector
                  onTap: () {
                    Navigator.push( // Переходим на экран детализации задачи при нажатии
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailScreen(task: task),
                      ),
                    );
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ListTile(
                      title: Text(task.title),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(task.isCompleted ? Icons.check_box : Icons.check_box_outline_blank),
                            onPressed: () {
                              setState(() {
                                task.isCompleted = !task.isCompleted;
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(task.isFavourite ? Icons.star : Icons.star_border, color: task.isFavourite ? Colors.yellow : null),
                            onPressed: () {
                              setState(() {
                                task.isFavourite = !task.isFavourite;
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              taskProvider.deleteTask(task.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                _showTaskForm(context, widget.category);
              },
              child: Text('Добавить задачу'),
            ),
          ),
        ],
      ),
    );
  }

  List<models.Task> _getFilteredTasks(TaskProvider taskProvider) {
    return taskProvider.filterTasks(widget.category.id, _selectedFilter == 'All' ? TaskFilter.all :
    _selectedFilter == 'Completed' ? TaskFilter.completed :
    _selectedFilter == 'Incomplete' ? TaskFilter.incomplete :
    _selectedFilter == 'Favourite' ? TaskFilter.favourite : TaskFilter.all);
  }

  void _showTaskForm(BuildContext context, models.Category category) {
    TextEditingController _titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Добавить задачу'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Название задачи'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isNotEmpty) {
                  Provider.of<TaskProvider>(context, listen: false).addTask(_titleController.text, '', category.id);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Добавить'),
            ),
          ],
        );
      },
    );
  }
}
