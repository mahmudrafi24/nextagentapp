import 'package:get/get.dart';
import '../../data/datasources/local/storage_service.dart';
import '../../domain/usecases/get_morning_briefing_usecase.dart';
import '../../core/utils/app_date_utils.dart';

class HomeController extends GetxController {
  final GetMorningBriefingUseCase _getMorningBriefingUseCase;
  final StorageService _storageService;

  HomeController({
    required GetMorningBriefingUseCase getMorningBriefingUseCase,
    required StorageService storageService,
  })  : _getMorningBriefingUseCase = getMorningBriefingUseCase,
        _storageService = storageService;

  final RxString greeting = ''.obs;
  final RxString userName = ''.obs;
  final RxString morningBriefing = ''.obs;
  final RxBool isLoadingBriefing = false.obs;
  final RxInt currentTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    userName.value = _storageService.getUserName() ?? '';
    greeting.value = AppDateUtils.getGreeting();
    fetchMorningBriefing();
  }

  Future<void> fetchMorningBriefing() async {
    isLoadingBriefing.value = true;
    final result = await _getMorningBriefingUseCase(userName: userName.value);
    result.fold(
      (failure) =>
          morningBriefing.value = 'Welcome back! Ready for a productive day?',
      (data) => morningBriefing.value = data,
    );
    isLoadingBriefing.value = false;
  }

  void changeTab(int index) {
    currentTabIndex.value = index;
  }
}
