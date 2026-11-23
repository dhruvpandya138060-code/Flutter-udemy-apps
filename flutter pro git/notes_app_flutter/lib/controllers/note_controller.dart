import 'package:get/get.dart';
import '../database/database_helper.dart';
import '../models/note_model.dart';

class NoteController extends GetxController {
  final notes = <Note>[].obs;
  final isLoading = false.obs;
  final error = RxnString();

  @override
  void onInit() {
    super.onInit();
    loadNotes();
  }

  Future<void> loadNotes() async {
    isLoading.value = true;
    try {
      error.value = null;
      notes.assignAll(await DatabaseHelper.instance.getNotes());
    } catch (e) {
      error.value = 'Unable to load notes: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addNote(Note note) async {
    try {
      await DatabaseHelper.instance.addNote(note);
      await loadNotes();
      return error.value == null;
    } catch (e) {
      error.value = 'Unable to add note: $e';
      return false;
    }
  }

  Future<bool> updateNote(Note note) async {
    try {
      await DatabaseHelper.instance.updateNote(note);
      await loadNotes();
      return error.value == null;
    } catch (e) {
      error.value = 'Unable to update note: $e';
      return false;
    }
  }

  Future<void> deleteNote(int id) async {
    try {
      await DatabaseHelper.instance.deleteNote(id);
      await loadNotes();
    } catch (e) {
      error.value = 'Unable to delete note: $e';
    }
  }
}
