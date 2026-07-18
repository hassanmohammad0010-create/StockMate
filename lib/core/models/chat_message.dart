import 'package:uuid/uuid.dart';

enum MessageRole {
  user,
  assistant,
}

class ChatMessage {
  final String id;
  final String message;
  final MessageRole role;
  final DateTime time;
  final bool isStreaming;
  final bool isError;

  const ChatMessage({
    required this.id,
    required this.message,
    required this.role,
    required this.time,
    this.isStreaming = false,
    this.isError = false,
  });

  factory ChatMessage.user(String text) {
    return ChatMessage(
      id: const Uuid().v4(),
      message: text,
      role: MessageRole.user,
      time: DateTime.now(),
    );
  }

  factory ChatMessage.assistant(String text, {bool isStreaming = false, bool isError = false}) {
    return ChatMessage(
      id: const Uuid().v4(),
      message: text,
      role: MessageRole.assistant,
      time: DateTime.now(),
      isStreaming: isStreaming,
      isError: isError,
    );
  }

  ChatMessage copyWith({
    String? message,
    bool? isStreaming,
    bool? isError,
  }) {
    return ChatMessage(
      id: id,
      message: message ?? this.message,
      role: role,
      time: time,
      isStreaming: isStreaming ?? this.isStreaming,
      isError: isError ?? this.isError,
    );
  }

  // ═══════════════════════════════════════
  // 🔹 Serialization للحفظ في SharedPreferences
  // ═══════════════════════════════════════
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'role': role.name,
      'time': time.toIso8601String(),
      'isError': isError,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? const Uuid().v4(),
      message: json['message'] ?? '',
      role: MessageRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => MessageRole.user,
      ),
      time: DateTime.tryParse(json['time'] ?? '') ?? DateTime.now(),
      isError: json['isError'] ?? false,
    );
  }
}