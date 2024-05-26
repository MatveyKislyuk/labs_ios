import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'task_provider.dart';
import 'models.dart' as models;

class TaskDetailScreen extends StatefulWidget {
  final models.Task task;

  TaskDetailScreen({required this.task});

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      String filePath = result.files.single.path!;
      Provider.of<TaskProvider>(context, listen: false).attachFileToTask(widget.task.id, filePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    var taskProvider = Provider.of<TaskProvider>(context);
    var createdAt = widget.task.createdAt;
    var formattedDate = '${createdAt.day.toString().padLeft(2, '0')}.${createdAt.month.toString().padLeft(2, '0')}.${createdAt.year}';
    var formattedTime = '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: Text('Детали задачи'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              taskProvider.deleteTask(widget.task.id);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Название задачи',
                labelStyle: TextStyle(fontSize: 22.0),
              ),
              style: TextStyle(fontSize: 30.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Создана: $formattedDate $formattedTime',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 10),
            Expanded(
              child: TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Описание задачи',
                  labelStyle: TextStyle(fontSize: 22.0),
                ),
                style: TextStyle(fontSize: 26.0),
                maxLines: null,
                expands: true,
              ),
            ),
            SizedBox(height: 10),
            IconButton(
              icon: Icon(Icons.attach_file),
              onPressed: _pickFile,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.task.title = _titleController.text;
                  widget.task.description = _descriptionController.text;
                  taskProvider.updateTask(widget.task);
                });
                Navigator.of(context).pop();
              },
              child: Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}
