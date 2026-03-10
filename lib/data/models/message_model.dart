import '../../domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    required super.id,
    required super.role,
    required super.content,
    required super.timestamp,
    super.conversationId,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] as String,
      role: map['role'] as String,
      content: map['content'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      conversationId: map['conversationId'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'role': role,
        'content': content,
        'timestamp': timestamp.toIso8601String(),
        'conversationId': conversationId,
      };

  factory MessageModel.fromEntity(Message message) {
    return MessageModel(
      id: message.id,
      role: message.role,
      content: message.content,
      timestamp: message.timestamp,
      conversationId: message.conversationId,
    );
  }
}
