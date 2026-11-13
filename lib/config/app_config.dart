import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  AppConfig._();

  static Future<void> load() => dotenv.load(fileName: '.env', isOptional: true);

  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';

  static String get apiKey => dotenv.env['API_KEY'] ?? '';
}