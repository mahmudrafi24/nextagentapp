import 'package:get/get.dart';
import '../../data/datasources/local/storage_service.dart';
import '../../domain/usecases/get_morning_briefing_usecase.dart';
import '../../domain/repositories/chat_repository.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController(
          getMorningBriefingUseCase: GetMorningBriefingUseCase(
            repository: Get.find<ChatRepository>(),
          ),
          storageService: Get.find<StorageService>(),
        ));
  }
}
