import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiKeys {
  /// مفتاح OpenRouter من ملف .env
  static String get openRouterApiKey {
    return dotenv.env['OPENROUTER_API_KEY'] ?? '';
  }
  
  /// مفتاح Gemini من ملف .env
  static String get geminiApiKey {
    return dotenv.env['GEMINI_API_KEY'] ?? '';
  }
  
  /// التحقق من وجود المفاتيح
  static bool get hasValidKeys {
    return openRouterApiKey.isNotEmpty && 
           openRouterApiKey.startsWith('sk-or-v1-');
  }
}