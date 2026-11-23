import 'package:flutter_test/flutter_test.dart';
import 'package:notes_app/models/note_model.dart';

void main() {
  test('Note can be serialized and restored', () {
    const note = Note(id: 1, title: 'Hello', content: 'World', date: '2026-11-23');
    final restored = Note.fromMap(note.toMap());
    expect(restored.id, 1);
    expect(restored.title, 'Hello');
    expect(restored.content, 'World');
  });
}
