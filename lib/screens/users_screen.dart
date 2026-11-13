import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _setError(String msg) {
    if (mounted) setState(() => _error = msg);
  }

  Future<void> _fetch() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await http
          .get(Uri.parse('${AppConfig.baseUrl}/users'),
              headers: {'x-api-key': AppConfig.apiKey})
          .timeout(const Duration(seconds: 10));
      debugPrint('GET /users -> ${res.statusCode}');
      if (res.statusCode != 200) throw HttpException('Status ${res.statusCode}');
      final data = (jsonDecode(res.body) as List).cast<Map<String, dynamic>>();
      if (mounted) setState(() => _users = data);
    } on SocketException {
      _setError('Tidak ada koneksi internet.');
    } on TimeoutException {
      _setError('Permintaan melebihi batas waktu.');
    } on HttpException catch (e) {
      _setError('Server error: ${e.message}');
    } on FormatException {
      _setError('Format data tidak valid.');
    } catch (_) {
      _setError('Terjadi kesalahan tak terduga.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (_loading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (_error != null) {
      body = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 8),
            Text(_error!),
            const SizedBox(height: 8),
            FilledButton(onPressed: _fetch, child: const Text('Coba Lagi')),
          ],
        ),
      );
    } else {
      body = ListView.builder(
        itemCount: _users.length,
        itemBuilder: (_, i) => ListTile(
          leading: CircleAvatar(child: Text('${_users[i]['id']}')),
          title: Text('${_users[i]['name']}'),
          subtitle: Text('${_users[i]['email']}'),
        ),
      );
    }
    return Scaffold(appBar: AppBar(title: const Text('Data Pengguna (API)')), body: body);
  }
}