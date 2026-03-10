import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../core/network/dio_client.dart';
import '../../core/network/network_info.dart';
import '../../data/datasources/local/hive_service.dart';
import '../../data/datasources/local/storage_service.dart';
import '../../data/datasources/remote/openclaw_api_service.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../data/repositories/notes_repository_impl.dart';
import '../../data/repositories/todo_repository_impl.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/repositories/notes_repository.dart';
import '../../domain/repositories/todo_repository.dart';
import '../../presentation/controllers/persona_controller.dart';
import '../../presentation/controllers/settings_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Services
    final storageService = StorageService();
    Get.put<StorageService>(storageService, permanent: true);

    final hiveService = HiveService();
    Get.put<HiveService>(hiveService, permanent: true);

    final networkInfo = NetworkInfo();
    Get.put<NetworkInfo>(networkInfo, permanent: true);

    // Dio & API
    final apiKey = storageService.getApiKey() ?? '';
    final dio = DioClient.createDio(apiKey);
    Get.put<Dio>(dio, permanent: true);

    final apiService = OpenClawApiService(dio: dio);
    Get.put<OpenClawApiService>(apiService, permanent: true);

    // Repositories
    Get.put<ChatRepository>(
      ChatRepositoryImpl(
        apiService: apiService,
        hiveService: hiveService,
        networkInfo: networkInfo,
      ),
      permanent: true,
    );

    Get.put<TodoRepository>(
      TodoRepositoryImpl(
        hiveService: hiveService,
        apiService: apiService,
        networkInfo: networkInfo,
      ),
      permanent: true,
    );

    Get.put<NotesRepository>(
      NotesRepositoryImpl(
        hiveService: hiveService,
        apiService: apiService,
        networkInfo: networkInfo,
      ),
      permanent: true,
    );

    // Global Controllers
    Get.put<SettingsController>(
      SettingsController(
        storageService: storageService,
        hiveService: hiveService,
      ),
      permanent: true,
    );

    Get.put<PersonaController>(
      PersonaController(storageService: storageService),
      permanent: true,
    );
  }
}
