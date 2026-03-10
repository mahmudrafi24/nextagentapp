import 'package:get/get.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/usecases/improve_text_usecase.dart';
import '../controllers/writing_controller.dart';

class WritingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WritingController>(() => WritingController(
          improveTextUseCase: ImproveTextUseCase(
            repository: Get.find<ChatRepository>(),
          ),
        ));
  }
}
