import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/todo.dart';
class ApiCall {
  static const root = 'https://jsonplaceholder.typicode.com/todos';
  Future<List<Todo>> fetchTodos() async {
    final response = await http.get(Uri.parse('$root?_limit=15'))
        .timeout(const Duration(seconds: 12));
    if (response.statusCode != 200) throw Exception('Unable to fetch todos');
    return (jsonDecode(response.body) as List)
      .map((e) => Todo.fromJson(e as Map<String, dynamic>)).toList();
  }
  Future<void> createTodo(Todo todo) async {
    final response = await http.post(Uri.parse(root),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(todo.toJson())).timeout(const Duration(seconds: 12));
    if (response.statusCode != 201) throw Exception('Create request failed');
  }
  Future<void> updateTodo(Todo todo) async {
    final response = await http.put(Uri.parse('$root/${todo.id}'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(todo.toJson())).timeout(const Duration(seconds: 12));
    if (response.statusCode != 200) throw Exception('Update request failed');
  }
  Future<void> deleteTodo(int id) async {
    final response = await http.delete(Uri.parse('$root/$id'))
        .timeout(const Duration(seconds: 12));
    if (response.statusCode != 200) throw Exception('Delete request failed');
  }
}
