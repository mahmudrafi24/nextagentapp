import '../../core/errors/result.dart';
import '../entities/message.dart';

abstract class ChatRepository {
  Future<Result<String>> sendMessage({
    required List<Map<String, dynamic>> messages,
    String? systemPrompt,
    int maxTokens,
  });

  Future<Result<List<Message>>> getChatHistory(String conversationId);

  Future<Result<void>> saveChatMessage(Message message);

  Future<Result<void>> clearChatHistory(String conversationId);

  Future<Result<List<String>>> getConversationIds();
}
