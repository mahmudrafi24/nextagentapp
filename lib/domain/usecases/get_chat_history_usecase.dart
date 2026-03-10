import '../../core/errors/result.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class GetChatHistoryUseCase {
  final ChatRepository _repository;

  GetChatHistoryUseCase({required ChatRepository repository})
      : _repository = repository;

  Future<Result<List<Message>>> call(String conversationId) {
    return _repository.getChatHistory(conversationId);
  }
}
