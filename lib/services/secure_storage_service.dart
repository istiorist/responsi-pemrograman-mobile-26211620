import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  /// Membuat service; [storage]
  SecureStorageService([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  String _key(String noteId) => 'note_content_$noteId';

  Future<void> saveContent(String noteId, String content) =>
      _storage.write(key: _key(noteId), value: content);

  Future<String?> getContent(String noteId) => _storage.read(key: _key(noteId));

  Future<void> deleteContent(String noteId) => _storage.delete(key: _key(noteId));
}