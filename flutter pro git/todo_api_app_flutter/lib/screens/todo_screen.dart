import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/api_call.dart';
class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});
  @override
  State<TodoScreen> createState() => _TodoScreenState();
}
class _TodoScreenState extends State<TodoScreen> {
  final api = ApiCall();
  List<Todo> todos = [];
  bool busy = false;
  String? error;
  int nextLocalId = 10000;
  @override
  void initState() { super.initState(); fetchTodos(); }
  Future<void> fetchTodos() async {
    setState(() {busy = true; error = null;});
    try {
      final result = await api.fetchTodos();
      if (mounted) setState(() => todos = result);
    } catch (e) { if(mounted) setState(() => error = '$e'); }
    finally { if (mounted) setState(() => busy = false); }
  }
  Future<void> addTodo() async {
    final controller = TextEditingController();
    final title = await showDialog<String>(context: context,
      builder: (context) => AlertDialog(title: const Text('New todo'),
        content: TextField(controller: controller, autofocus: true,
          decoration: const InputDecoration(labelText: 'Task')),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, controller.text.trim()), child: const Text('Save'))]));
    controller.dispose();
    if (title == null || title.isEmpty || !mounted) return;
    final todo = Todo(id: nextLocalId++, title: title, completed: false);
    try {
      await api.createTodo(todo);
      if (mounted) setState(() => todos.insert(0, todo));
    } catch (e) { _message('$e'); }
  }
  Future<void> toggle(Todo todo, bool checked) async {
    final changed = Todo(id: todo.id, title: todo.title, completed: checked);
    try {
      // JSONPlaceholder only simulates updates. Locally added tasks use an existing demo id.
      await api.updateTodo(Todo(id: todo.id >= 10000 ? 1 : todo.id,
        title: changed.title, completed: checked));
      if (mounted) setState(() => todo.completed = checked);
    } catch (e) { _message('$e'); }
  }
  Future<void> remove(Todo todo) async {
    try {
      await api.deleteTodo(todo.id >= 10000 ? 1 : todo.id);
      if (mounted) setState(() => todos.remove(todo));
    } catch (e) { _message('$e'); }
  }
  Future<void> edit(Todo todo) async {
    final controller = TextEditingController(text: todo.title);
    final value = await showDialog<String>(context: context,
      builder: (context) => AlertDialog(title: const Text('Edit todo'),
        content: TextField(controller: controller, decoration: const InputDecoration(labelText: 'Task')),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, controller.text.trim()), child: const Text('Save'))]));
    controller.dispose();
    if (value == null || value.isEmpty || !mounted) return;
    try {
      await api.updateTodo(Todo(id: todo.id >= 10000 ? 1 : todo.id,
        title: value, completed: todo.completed));
      if (mounted) setState(() => todo.title = value);
    } catch (e) { _message('$e'); }
  }
  void _message(String text) { if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text))); }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Todo App'), actions: [IconButton(
      onPressed: busy ? null : fetchTodos, icon: const Icon(Icons.refresh))]),
    body: busy ? const Center(child: CircularProgressIndicator()) :
      error != null ? Center(child: Text('Error: $error')) :
      ListView.builder(itemCount: todos.length, itemBuilder: (context, i) {
        final todo = todos[i];
        return ListTile(
          leading: Checkbox(value: todo.completed, onChanged: (v) { if(v != null) toggle(todo, v); }),
          title: Text(todo.title, style: TextStyle(
            decoration: todo.completed ? TextDecoration.lineThrough : null)),
          trailing: Wrap(mainAxisSize: MainAxisSize.min, children: [
            IconButton(onPressed: () => edit(todo), icon: const Icon(Icons.edit)),
            IconButton(onPressed: () => remove(todo), icon: const Icon(Icons.delete)),
          ]),
        );
      }),
    floatingActionButton: FloatingActionButton(onPressed: addTodo,
      child: const Icon(Icons.add)),
  );
}
