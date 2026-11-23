class Todo {
  final int id;
  String title;
  bool completed;
  Todo({required this.id, required this.title, required this.completed});
  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    id: (json['id'] as num).toInt(), title: json['title'].toString(),
    completed: json['completed'] == true,
  );
  Map<String, dynamic> toJson() => {
    'id': id, 'title': title, 'completed': completed, 'userId': 1,
  };
}
