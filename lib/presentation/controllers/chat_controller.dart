import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../data/datasources/local/storage_service.dart';
import '../../data/models/persona_model.dart';
import '../../data/models/persona_prompts.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/send_message_usecase.dart';
import '../../domain/usecases/get_chat_history_usecase.dart';
import '../../domain/repositories/chat_repository.dart';

class ChatController extends GetxController {
  final SendMessageUseCase _sendMessageUseCase;
  final GetChatHistoryUseCase _getChatHistoryUseCase;
  final ChatRepository _chatRepository;
  final StorageService _storageService;

  ChatController({
    required SendMessageUseCase sendMessageUseCase,
    required GetChatHistoryUseCase getChatHistoryUseCase,
    required ChatRepository chatRepository,
    required StorageService storageService,
  })  : _sendMessageUseCase = sendMessageUseCase,
        _getChatHistoryUseCase = getChatHistoryUseCase,
        _chatRepository = chatRepository,
        _storageService = storageService;

  final RxList<Message> messages = <Message>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString inputText = ''.obs;
  final RxString conversationId = ''.obs;

  final TextEditingController inputController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final _uuid = const Uuid();

  @override
  void onInit() {
    super.onInit();
    conversationId.value = Get.arguments?['conversationId'] ?? _uuid.v4();
    _loadChatHistory();
  }

  @override
  void onClose() {
    inputController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  Future<void> _loadChatHistory() async {
    final result = await _getChatHistoryUseCase(conversationId.value);
    result.fold(
      (failure) {},
      (data) => messages.assignAll(data),
    );
  }

  Future<void> sendMessage() async {
    if (inputText.value.trim().isEmpty) return;

    final userMessage = Message(
      id: _uuid.v4(),
      role: 'user',
      content: inputText.value.trim(),
      timestamp: DateTime.now(),
      conversationId: conversationId.value,
    );

    messages.add(userMessage);
    await _chatRepository.saveChatMessage(userMessage);
    inputController.clear();
    inputText.value = '';
    isLoading.value = true;
    errorMessage.value = '';
    _scrollToBottom();

    final personaMode = PersonaMode.values.firstWhere(
      (e) => e.name == _storageService.getCurrentPersona(),
      orElse: () => PersonaMode.assistant,
    );

    final userProfile = UserProfile(
      name: _storageService.getUserName(),
    );

    final systemPrompt =
        PersonaPrompts.buildSystemPromptWithMemory(personaMode, userProfile);

    final apiMessages = messages.map((m) => m.toApiMap()).toList();

    final result = await _sendMessageUseCase(
      messages: apiMessages,
      systemPrompt: systemPrompt,
    );

    result.fold(
      (failure) {
        errorMessage.value = failure.message;
      },
      (response) {
        final assistantMessage = Message(
          id: _uuid.v4(),
          role: 'assistant',
          content: response,
          timestamp: DateTime.now(),
          conversationId: conversationId.value,
        );
        messages.add(assistantMessage);
        _chatRepository.saveChatMessage(assistantMessage);
        _scrollToBottom();
      },
    );

    isLoading.value = false;
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void clearChat() {
    messages.clear();
    _chatRepository.clearChatHistory(conversationId.value);
    conversationId.value = _uuid.v4();
  }
}
