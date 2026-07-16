import 'package:flutter/services.dart';

class PromptManager {
  static String? _prompt;

  static Future<void> initialize() async {
    _prompt = await rootBundle.loadString(
      'assets/prompts/system_prompt.txt',
    );
  }

  static String get prompt => _prompt ?? "";
}