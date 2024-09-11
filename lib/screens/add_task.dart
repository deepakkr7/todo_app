import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo1/model/todomodel.dart';
import 'package:todo1/services/api_services.dart';
import 'package:todo1/services/database.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task;

  AddTaskScreen({this.task});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String description;
  DateTime? dueDate;
  final APIService _apiService = APIService();

  @override
  void initState() {
    super.initState();
    title = widget.task?.title ?? '';
    description = widget.task?.description ?? '';
    dueDate = widget.task?.dueDate ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: title,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) {
                  title = value!;
                },
              ),
              TextFormField(
                initialValue: description,
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  description = value!;
                },
              ),
              ListTile(
                title: Text('Due Date: ${DateFormat.yMd().format(dueDate!)}'),
                trailing: Icon(Icons.calendar_today),
                onTap: _pickDate,
              ),
              ElevatedButton(
                onPressed: _saveTask,
                child: Text(widget.task == null ? 'Add Task' : 'Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dueDate!,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        dueDate = picked;
      });
    }
  }

  void _saveTask() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Task task = Task(
        title: title,
        description: description,
        dueDate: dueDate!,
        isCompleted: widget.task?.isCompleted ?? false,
        id: widget.task?.id,
      );

      if (widget.task == null) {
        await TaskDatabase.instance.insertTask(task);
        await _syncTaskToAPI(task);
      } else {
        await TaskDatabase.instance.updateTask(task);
        await _syncTaskToAPI(task);
      }

      Navigator.pop(context);
    }
  }


  Future<void> _syncTaskToAPI(Task task) async {
    try {
      await _apiService.postTask(task);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task synced successfully with API!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sync task with API: $e')),
      );
    }
  }
}
