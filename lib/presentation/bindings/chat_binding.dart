import 'package:get/get.dart';
import '../../data/datasources/local/storage_service.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/usecases/send_message_usecase.dart';
import '../../domain/usecases/get_chat_history_usecase.dart';
import '../controllers/chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    final chatRepo = Get.find<ChatRepository>();

    Get.lazyPut<ChatController>(() => ChatController(
          sendMessageUseCase: SendMessageUseCase(repository: chatRepo),
          getChatHistoryUseCase: GetChatHistoryUseCase(repository: chatRepo),
          chatRepository: chatRepo,
          storageService: Get.find<StorageService>(),
        ));
  }
}
