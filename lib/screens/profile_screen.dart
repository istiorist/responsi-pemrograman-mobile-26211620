import 'package:flutter/material.dart';
import '../models/student.dart';
import '../utils/validators.dart';
import '../widgets/profile_card.dart';

class ProfileScreen extends StatefulWidget {
  final Student student;
  final void Function(Student) onSave;
  const ProfileScreen({super.key, required this.student, required this.onSave});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Student _student = widget.student;

  Future<void> _edit() async {
    final updated = await showDialog<Student>(
      context: context,
      builder: (_) => _EditDialog(student: _student),
    );
    if (updated == null) return;
    widget.onSave(updated);
    setState(() => _student = updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Mahasiswa')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ProfileCard(student: _student),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _edit,
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profil'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditDialog extends StatefulWidget {
  final Student student;
  const _EditDialog({required this.student});

  @override
  State<_EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<_EditDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.student.name);
  late final _nim = TextEditingController(text: widget.student.nim);
  late final _prodi = TextEditingController(text: widget.student.programStudi);
  late final _email = TextEditingController(text: widget.student.email);

  @override
  void dispose() {
    _name.dispose();
    _nim.dispose();
    _prodi.dispose();
    _email.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      Student(
        name: Validators.sanitize(_name.text),
        nim: Validators.sanitize(_nim.text),
        programStudi: Validators.sanitize(_prodi.text),
        email: _email.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Profil'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (v) => Validators.validateRequired(v, 'Nama'),
              ),
              TextFormField(
                controller: _nim,
                decoration: const InputDecoration(labelText: 'NIM'),
                validator: (v) => Validators.validateRequired(v, 'NIM'),
              ),
              TextFormField(
                controller: _prodi,
                decoration: const InputDecoration(labelText: 'Program Studi'),
                validator: (v) => Validators.validateRequired(v, 'Program studi'),
              ),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: Validators.validateEmail,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
        FilledButton(onPressed: _save, child: const Text('Simpan')),
      ],
    );
  }
}