import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static Future<void> load() async {
    const definedUrl = String.fromEnvironment('API_URL');
    if (definedUrl.isEmpty) {
      await dotenv.load(fileName: '.env');
    }
  }

  static String get apiUrl {
    const defined = String.fromEnvironment('API_URL');
    if (defined.isNotEmpty) return defined;
    return dotenv.env['API_URL'] ?? 'http://localhost:3000';
  }
}
