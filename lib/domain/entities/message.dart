class Message {
  final String id;
  final String role;
  final String content;
  final DateTime timestamp;
  final String? conversationId;

  const Message({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.conversationId,
  });

  Map<String, dynamic> toApiMap() => {
        'role': role,
        'content': content,
      };
}
