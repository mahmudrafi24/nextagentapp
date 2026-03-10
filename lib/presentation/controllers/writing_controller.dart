import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/usecases/improve_text_usecase.dart';
import '../../core/widgets/error_snackbar.dart';

class WritingController extends GetxController {
  final ImproveTextUseCase _improveTextUseCase;

  WritingController({required ImproveTextUseCase improveTextUseCase})
      : _improveTextUseCase = improveTextUseCase;

  final RxString inputText = ''.obs;
  final RxString outputText = ''.obs;
  final RxString selectedMode = 'improve'.obs;
  final RxBool isLoading = false.obs;
  final RxString targetLanguage = 'Spanish'.obs;

  final TextEditingController inputController = TextEditingController();

  static const List<Map<String, String>> writingModes = [
    {'key': 'improve', 'label': 'Improve', 'icon': '✏️'},
    {'key': 'rewrite', 'label': 'Rewrite', 'icon': '🔄'},
    {'key': 'professional', 'label': 'Professional', 'icon': '💼'},
    {'key': 'casual', 'label': 'Casual', 'icon': '😊'},
    {'key': 'shorter', 'label': 'Shorter', 'icon': '📝'},
    {'key': 'translate', 'label': 'Translate', 'icon': '🌐'},
  ];

  @override
  void onClose() {
    inputController.dispose();
    super.onClose();
  }

  void selectMode(String mode) {
    selectedMode.value = mode;
    if (inputText.value.isNotEmpty) {
      processText();
    }
  }

  Future<void> processText() async {
    if (inputText.value.trim().isEmpty) return;

    isLoading.value = true;
    outputText.value = '';

    final result = await _improveTextUseCase(
      text: inputText.value.trim(),
      mode: selectedMode.value,
      targetLanguage:
          selectedMode.value == 'translate' ? targetLanguage.value : null,
    );

    result.fold(
      (failure) {
        showErrorSnackbar(failure.message);
      },
      (data) {
        outputText.value = data;
      },
    );

    isLoading.value = false;
  }

  void copyOutput() {
    if (outputText.value.isNotEmpty) {
      showSuccessSnackbar('Copied to clipboard!');
    }
  }

  void clearAll() {
    inputController.clear();
    inputText.value = '';
    outputText.value = '';
  }
}
