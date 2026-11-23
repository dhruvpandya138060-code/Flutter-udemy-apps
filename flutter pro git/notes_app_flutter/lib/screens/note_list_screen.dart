import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/note_controller.dart';
import '../models/note_model.dart';
import 'note_detail_screen.dart';

class NoteListScreen extends StatelessWidget {
  NoteListScreen({super.key});
  final NoteController controller = Get.find<NoteController>();

  Future<void> _confirmDelete(BuildContext context, Note note) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete note?'),
        content: Text('Delete "${note.title}" permanently?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed == true && note.id != null) {
      await controller.deleteNote(note.id!);
      if (context.mounted && controller.error.value != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(controller.error.value!)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Notes'), actions: [
        IconButton(tooltip: 'Refresh notes', onPressed: controller.loadNotes, icon: const Icon(Icons.refresh)),
      ]),
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
        if (controller.error.value != null) {
          return Center(child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(controller.error.value!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: controller.loadNotes, child: const Text('Retry')),
            ]),
          ));
        }
        if (controller.notes.isEmpty) {
          return const Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.note_alt_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 12),
            Text('No notes yet. Tap + to create one.'),
          ]));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: controller.notes.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final note = controller.notes[index];
            return Card(child: ListTile(
              title: Text(note.title, maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text(note.content, maxLines: 2, overflow: TextOverflow.ellipsis),
              onTap: () => Get.to(() => NoteDetailScreen(note: note)),
              trailing: IconButton(
                tooltip: 'Delete ${note.title}',
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _confirmDelete(context, note),
              ),
            ));
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const NoteDetailScreen()),
        tooltip: 'Add note',
        child: const Icon(Icons.add),
      ),
    );
  }
}
