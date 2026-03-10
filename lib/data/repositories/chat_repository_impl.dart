import '../../core/errors/exceptions.dart';
import '../../core/errors/result.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/local/hive_service.dart';
import '../datasources/remote/openclaw_api_service.dart';
import '../models/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final OpenClawApiService _apiService;
  final HiveService _hiveService;
  final NetworkInfo _networkInfo;

  ChatRepositoryImpl({
    required OpenClawApiService apiService,
    required HiveService hiveService,
    required NetworkInfo networkInfo,
  })  : _apiService = apiService,
        _hiveService = hiveService,
        _networkInfo = networkInfo;

  @override
  Future<Result<String>> sendMessage({
    required List<Map<String, dynamic>> messages,
    String? systemPrompt,
    int maxTokens = 1024,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Error(NetworkFailure());
    }

    try {
      final response = await _apiService.sendMessage(
        messages: messages,
        systemPrompt: systemPrompt,
        maxTokens: maxTokens,
      );
      return Success(response);
    } on ServerException catch (e) {
      return Error(ApiFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Error(ApiFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<Message>>> getChatHistory(String conversationId) async {
    try {
      final maps = _hiveService.getChatHistory(conversationId);
      final messages =
          maps.map((m) => MessageModel.fromMap(m) as Message).toList();
      return Success(messages);
    } catch (e) {
      return Error(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> saveChatMessage(Message message) async {
    try {
      final model = MessageModel.fromEntity(message);
      await _hiveService.saveChatMessage(
        message.conversationId ?? 'default',
        model.toMap(),
      );
      return const Success(null);
    } catch (e) {
      return Error(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> clearChatHistory(String conversationId) async {
    try {
      await _hiveService.clearChatHistory(conversationId);
      return const Success(null);
    } catch (e) {
      return Error(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<List<String>>> getConversationIds() async {
    try {
      final ids = _hiveService.getConversationIds();
      return Success(ids);
    } catch (e) {
      return Error(CacheFailure(e.toString()));
    }
  }
}
