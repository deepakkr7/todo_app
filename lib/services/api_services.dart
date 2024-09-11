
import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:todo1/model/todomodel.dart';

class APIService{
  final String Url='https://jsonplaceholder.typicode.com/todos';
  Future<List<Task>> fetchTask() async{
    final response= await http.get(Uri.parse(Url));
    if(response.statusCode==200){
      final List task=jsonDecode(response.body);
      return task.map((task) => Task.fromMap(task)).toList();
    }
    else{
      throw Exception('Failed to Load');
    }
  }
  Future<void>postTask(Task task) async{
    final response=await http.post(Uri.parse(Url),
    headers:{'Content-Type':'application/json'},
    body:jsonEncode(task.toMap()));
    if(response.statusCode!=201){
      throw Exception('Failed to post task');
    }

  }
}