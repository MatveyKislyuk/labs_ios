import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_provider.dart';
import 'models.dart' as models;
import 'task_screen.dart';
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

