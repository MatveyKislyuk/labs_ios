import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_provider.dart';
import 'models.dart' as models;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MaterialApp(
        home: CategoryScreen(),
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: AppBarTheme(
            color: Colors.blueAccent,
            elevation: 4.0,
            toolbarHeight: 120.0,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Colors.blueAccent,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var taskProvider = Provider.of<TaskProvider>(context);
    return Scaffold(
      appBar: AppBar(
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: taskProvider.categories.length,
              itemBuilder: (context, index) {
                var category = taskProvider.categories[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(category.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showCategoryForm(context, category: category);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _showDeleteCategoryDialog(context, category);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => TaskScreen(category: category),
                      ));
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCategoryForm(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

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
    var tasks = taskProvider.filterTasks(widget.category.id, _selectedFilter);
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
                return Card(
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
}

void _showCategoryForm(BuildContext context, {models.Category? category}) {
  TextEditingController _nameController = TextEditingController(text: category?.name ?? '');

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(category != null ? 'Редактировать категорию' : 'Создать категорию'),
        content: TextField(
          controller: _nameController,
          decoration: InputDecoration(labelText: 'Название категории'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty) {
                if (category != null) {
                  Provider.of<TaskProvider>(context, listen: false).updateCategory(category.id, _nameController.text);
                } else {
                  Provider.of<TaskProvider>(context, listen: false).addCategory(_nameController.text);
                }
                Navigator.of(context).pop();
              }
            },
            child: Text(category != null ? 'Сохранить' : 'Создать'),
          ),
        ],
      );
    },
  );
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

void _showDeleteCategoryDialog(BuildContext context, models.Category category) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Подтверждение удаления'),
        content: Text('Вы уверены, что хотите удалить категорию "${category.name}"? Все задачи в этой категории также будут удалены.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              Provider.of<TaskProvider>(context, listen: false).deleteCategory(category.id);
              Navigator.of(context).pop();
            },
            child: Text('Удалить'),
          ),
        ],
      );
    },
  );
}
