import '../../core/errors/result.dart';
import '../repositories/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository _repository;

  SendMessageUseCase({required ChatRepository repository})
      : _repository = repository;

  Future<Result<String>> call({
    required List<Map<String, dynamic>> messages,
    String? systemPrompt,
    int maxTokens = 1024,
  }) {
    return _repository.sendMessage(
      messages: messages,
      systemPrompt: systemPrompt,
      maxTokens: maxTokens,
    );
  }
}
