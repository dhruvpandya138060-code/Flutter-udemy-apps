class Note {
  final int? id;
  final String title;
  final String content;
  final String date;

  const Note({this.id, required this.title, required this.content, required this.date});

  Note copyWith({int? id, String? title, String? content, String? date}) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
    );
  }

  Map<String, Object?> toMap() => {
    'id': id,
    'title': title,
    'content': content,
    'date': date,
  };

  factory Note.fromMap(Map<String, dynamic> map) => Note(
    id: (map['id'] as num?)?.toInt(),
    title: map['title'] as String? ?? '',
    content: map['content'] as String? ?? '',
    date: map['date'] as String? ?? '',
  );
}
