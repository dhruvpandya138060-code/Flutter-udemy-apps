import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../models/note_model.dart';

/// Uses SQLite on Android/iOS and SharedPreferences on web for easy Chrome demos.
/// For production apps, use a database backend with a supported web implementation.
class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();
  static const _webKey = 'notes_app_notes';
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    final dbPath = await getDatabasesPath();
    _database = await openDatabase(
      join(dbPath, 'notes.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            content TEXT NOT NULL,
            date TEXT NOT NULL
          )
        ''');
      },
    );
    return _database!;
  }

  Future<List<Note>> getNotes() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final encoded = prefs.getString(_webKey);
      if (encoded == null) return [];
      final decoded = jsonDecode(encoded) as List<dynamic>;
      return decoded.map((item) => Note.fromMap(Map<String, dynamic>.from(item as Map))).toList()
        ..sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));
    }
    final db = await database;
    final rows = await db.query('notes', orderBy: 'id DESC');
    return rows.map((row) => Note.fromMap(row)).toList();
  }

  Future<void> addNote(Note note) async {
    if (kIsWeb) {
      final notes = await getNotes();
      final newId = notes.fold<int>(0, (max, n) => (n.id ?? 0) > max ? n.id! : max) + 1;
      notes.insert(0, note.copyWith(id: newId));
      await _saveWeb(notes);
      return;
    }
    final db = await database;
    await db.insert('notes', note.toMap()..remove('id'));
  }

  Future<void> updateNote(Note note) async {
    if (note.id == null) return;
    if (kIsWeb) {
      final notes = await getNotes();
      final index = notes.indexWhere((n) => n.id == note.id);
      if (index >= 0) {
        notes[index] = note;
        await _saveWeb(notes);
      }
      return;
    }
    final db = await database;
    await db.update('notes', note.toMap()..remove('id'), where: 'id = ?', whereArgs: [note.id]);
  }

  Future<void> deleteNote(int id) async {
    if (kIsWeb) {
      final notes = await getNotes();
      notes.removeWhere((n) => n.id == id);
      await _saveWeb(notes);
      return;
    }
    final db = await database;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> _saveWeb(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_webKey, jsonEncode(notes.map((e) => e.toMap()).toList()));
  }
}
