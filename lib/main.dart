import 'package:flutter/material.dart';
import 'config/app_config.dart';
import 'providers/app_provider.dart';
import 'repositories/note_repository.dart';
import 'screens/home_screen.dart';
import 'services/secure_storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviderWrapper(
      repository: NoteRepository(SecureStorageService()),
      child: MaterialApp(
        title: 'Profil Mahasiswa',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
        home: const HomeScreen(),
      ),
    );
  }
}