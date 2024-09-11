import 'package:flutter/material.dart';
import 'package:todo1/model/todomodel.dart';
import 'package:todo1/screens/add_task.dart';
import 'package:todo1/services/api_services.dart';
import 'package:todo1/services/database.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Task>> _taskList;
  final APIService _apiservice=APIService();

  @override
  void initState() {
    super.initState();
    _refreshTasks();
  }

  void _refreshTasks() {
    setState(() {
      _taskList = TaskDatabase.instance.getTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
        actions: [
          IconButton(
            icon: Icon(Icons.sync),
            onPressed: _syncTasksWithAPI,
          ),
        ],
      ),
      body: FutureBuilder<List<Task>>(
        future: _taskList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text('No tasks available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Task task = snapshot.data![index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  trailing: Checkbox(
                    value: task.isCompleted,
                    onChanged: (bool? value) {
                      setState(() {
                        task.isCompleted = value ?? false;
                        TaskDatabase.instance.updateTask(task);
                        _refreshTasks();
                      });
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddTaskScreen(task: task),
                      ),
                    ).then((_) => _refreshTasks());
                  },
                  onLongPress: () {
                    TaskDatabase.instance.deleteTask(task.id!);
                    _refreshTasks();
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          ).then((_) => _refreshTasks());
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _syncTasksWithAPI() async{
    try {
      List<Task> apiTasks = await _apiservice.fetchTask();

      for (Task task in apiTasks) {
        await TaskDatabase.instance.insertTask(task);
      }


      _refreshTasks();


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tasks synced successfully with API!')),
      );
    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sync tasks with API: $e')),
      );
    }
  }
}
