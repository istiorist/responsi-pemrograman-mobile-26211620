import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.note_alt_outlined, size: 64),
          SizedBox(height: 12),
          Text('Belum ada catatan'),
          Text('Tekan tombol + untuk menambah'),
        ],
      ),
    );
  }
}