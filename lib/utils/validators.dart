class Validators {
  Validators._();

  static String sanitize(String input) =>
      input.replaceAll(RegExp('[<>"\']'), '').trim();

  static String? validateTitle(String? value) {
    final text = sanitize(value ?? '');
    if (text.isEmpty) return 'Judul wajib diisi';
    if (text.length < 3) return 'Judul minimal 3 karakter';
    if (text.length > 50) return 'Judul maksimal 50 karakter';
    return null;
  }

  static String? validateContent(String? value) {
    final text = sanitize(value ?? '');
    if (text.isEmpty) return 'Isi catatan wajib diisi';
    if (text.length < 10) return 'Isi minimal 10 karakter';
    if (text.length > 1000) return 'Isi maksimal 1000 karakter';
    return null;
  }

  static String? validateRequired(String? value, String label) {
    if (sanitize(value ?? '').isEmpty) return '$label wajib diisi';
    return null;
  }

  static String? validateEmail(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return 'Email wajib diisi';
    final ok = RegExp(r'^[\w\.\-+]+@[\w\-]+(\.[\w\-]+)+$').hasMatch(text);
    return ok ? null : 'Format email tidak valid';
  }
}