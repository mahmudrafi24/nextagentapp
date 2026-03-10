import 'package:get/get.dart';
import '../../data/datasources/local/storage_service.dart';
import '../../data/models/persona_model.dart';

class PersonaController extends GetxController {
  final StorageService _storageService;

  PersonaController({required StorageService storageService})
      : _storageService = storageService;

  final RxList<PersonaModel> personas =
      PersonaModel.defaultPersonas.obs;
  final Rx<PersonaMode> currentMode = PersonaMode.assistant.obs;

  @override
  void onInit() {
    super.onInit();
    final saved = _storageService.getCurrentPersona();
    currentMode.value = PersonaMode.values.firstWhere(
      (e) => e.name == saved,
      orElse: () => PersonaMode.assistant,
    );
  }

  void selectPersona(PersonaMode mode) {
    currentMode.value = mode;
    _storageService.saveCurrentPersona(mode.name);
  }
}
