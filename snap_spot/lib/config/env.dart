import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';
  static String get apiKey => dotenv.env['API_KEY'] ?? '';

  static Future<void> load() async {
    await dotenv.load(fileName: '.env', mergeWith: Platform.environment);
  }
}