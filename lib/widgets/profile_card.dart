import 'package:flutter/material.dart';
import '../models/student.dart';

class ProfileCard extends StatelessWidget {
  final Student student;
  const ProfileCard({super.key, required this.student});

  String get _initials {
    final parts =
        student.name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  Widget _row(IconData icon, String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 12),
            Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
            Expanded(child: Text(value)),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(_initials, style: const TextStyle(fontSize: 28)),
            ),
            const SizedBox(height: 16),
            Text(student.name, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            _row(Icons.badge, 'NIM', student.nim),
            _row(Icons.school, 'Prodi', student.programStudi),
            _row(Icons.email, 'Email', student.email),
          ],
        ),
      ),
    );
  }
}