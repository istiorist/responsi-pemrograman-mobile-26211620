import 'package:flutter/material.dart';
import '../models/note.dart';
import '../providers/app_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/note_card.dart';
import 'note_form_screen.dart';
import 'profile_screen.dart';
import 'users_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _addNote(BuildContext context) async {
    final ok = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const NoteFormScreen()),
    );
    if (ok == true && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Catatan tersimpan')));
    }
  }

  Future<void> _confirmDelete(BuildContext context, Note note) async {
    final app = AppProvider.read(context);
    final yes = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus catatan?'),
        content: Text('Catatan "${note.title}" akan dihapus permanen.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Hapus')),
        ],
      ),
    );
    if (yes == true) await app.deleteNote(note.id);
  }

  @override
  Widget build(BuildContext context) {
    final app = AppProvider.of(context);

    Widget list;
    if (app.isLoading) {
      list = const Center(child: CircularProgressIndicator());
    } else if (app.notes.isEmpty) {
      list = const EmptyState();
    } else {
      list = ListView.builder(
        itemCount: app.notes.length,
        itemBuilder: (_, i) => NoteCard(
          note: app.notes[i],
          onDelete: () => _confirmDelete(context, app.notes[i]),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Kuliah'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_outlined),
            tooltip: 'Data API',
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const UsersScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profil',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ProfileScreen(student: app.student, onSave: app.updateStudent),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(app.student.name),
            subtitle: Text(app.student.nim),
          ),
          const Divider(height: 1),
          Expanded(child: list),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNote(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}