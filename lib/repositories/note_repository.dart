import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';
import '../services/secure_storage_service.dart';

class NoteRepository {
  static const _metaKey = 'notes_metadata';
  final SecureStorageService _secure;

  NoteRepository(this._secure);

  Future<List<Map<String, dynamic>>> _readMeta(SharedPreferences prefs) async {
    final raw = prefs.getString(_metaKey);
    if (raw == null) return [];
    return (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
  }

  Future<List<Note>> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final meta = await _readMeta(prefs);
    final notes = <Note>[];
    for (final m in meta) {
      final content = await _secure.getContent(m['id'] as String) ?? '';
      notes.add(Note.fromMetadata(m, content));
    }
    return notes;
  }

  Future<void> addNote(Note note) async {
    final prefs = await SharedPreferences.getInstance();
    await _secure.saveContent(note.id, note.content);
    final meta = await _readMeta(prefs);
    meta.insert(0, note.toMetadata());
    await prefs.setString(_metaKey, jsonEncode(meta));
  }

  /// Menghapus catatan berdasarkan [id].
  Future<void> deleteNote(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final meta = await _readMeta(prefs)..removeWhere((m) => m['id'] == id);
    await prefs.setString(_metaKey, jsonEncode(meta));
    await _secure.deleteContent(id);
  }
}