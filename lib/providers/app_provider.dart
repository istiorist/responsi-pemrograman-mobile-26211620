import 'package:flutter/material.dart';
import '../models/note.dart';
import '../models/student.dart';
import '../repositories/note_repository.dart';

class AppProvider extends InheritedWidget {
  final Student student;
  final List<Note> notes;
  final bool isLoading;
  final void Function(Student) updateStudent;
  final Future<void> Function(Note) addNote;
  final Future<void> Function(String) deleteNote;

  const AppProvider({
    super.key,
    required this.student,
    required this.notes,
    required this.isLoading,
    required this.updateStudent,
    required this.addNote,
    required this.deleteNote,
    required super.child,
  });

  static AppProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppProvider>()!;

  static AppProvider read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<AppProvider>()!;

  @override
  bool updateShouldNotify(AppProvider old) =>
      student != old.student || notes != old.notes || isLoading != old.isLoading;
}

/// Wrapper stateful yang mengelola state dan menyediakan [AppProvider].
class AppProviderWrapper extends StatefulWidget {
  final Widget child;
  final NoteRepository repository;
  const AppProviderWrapper({super.key, required this.child, required this.repository});

  @override
  State<AppProviderWrapper> createState() => _AppProviderWrapperState();
}

class _AppProviderWrapperState extends State<AppProviderWrapper> {
  Student _student = const Student(
    name: 'Istiqomah',
    nim: '26.21.1620',
    programStudi: 'Informatika',
    email: 'ganti-email-kamu@students.amikom.ac.id',
  );
  List<Note> _notes = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final notes = await widget.repository.getNotes();
      if (!mounted) return;
      setState(() => _notes = notes);
    } catch (_) {
      debugPrint('Gagal memuat catatan');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _updateStudent(Student s) => setState(() => _student = s);

  Future<void> _addNote(Note n) async {
    await widget.repository.addNote(n);
    if (!mounted) return;
    setState(() => _notes = [n, ..._notes]);
  }

  Future<void> _deleteNote(String id) async {
    await widget.repository.deleteNote(id);
    if (!mounted) return;
    setState(() => _notes = _notes.where((n) => n.id != id).toList());
  }

  @override
  Widget build(BuildContext context) {
    return AppProvider(
      student: _student,
      notes: _notes,
      isLoading: _loading,
      updateStudent: _updateStudent,
      addNote: _addNote,
      deleteNote: _deleteNote,
      child: widget.child,
    );
  }
}