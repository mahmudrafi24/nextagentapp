import '../../core/errors/result.dart';
import '../repositories/chat_repository.dart';

class ImproveTextUseCase {
  final ChatRepository _repository;

  ImproveTextUseCase({required ChatRepository repository})
      : _repository = repository;

  Future<Result<String>> call({
    required String text,
    required String mode,
    String? targetLanguage,
  }) {
    String systemPrompt;
    switch (mode) {
      case 'improve':
        systemPrompt =
            'Fix grammar, clarity, and flow. Keep the original meaning. Return only the improved text.';
      case 'rewrite':
        systemPrompt =
            'Rephrase completely in a better, cleaner way. Return only the rewritten text.';
      case 'professional':
        systemPrompt =
            'Make formal and business-appropriate. Return only the professional version.';
      case 'casual':
        systemPrompt =
            'Make friendly and conversational. Return only the casual version.';
      case 'shorter':
        systemPrompt =
            'Summarize to key points only. Return only the shortened version.';
      case 'translate':
        systemPrompt =
            'Translate to ${targetLanguage ?? 'English'} naturally. Return only the translation.';
      default:
        systemPrompt =
            'Improve this text. Return only the improved version.';
    }

    return _repository.sendMessage(
      messages: [
        {'role': 'user', 'content': text},
      ],
      systemPrompt: systemPrompt,
    );
  }
}
