import '../../core/errors/result.dart';
import '../../data/models/persona_prompts.dart';
import '../repositories/chat_repository.dart';

class GetMorningBriefingUseCase {
  final ChatRepository _repository;

  GetMorningBriefingUseCase({required ChatRepository repository})
      : _repository = repository;

  Future<Result<String>> call({String? userName}) {
    final greeting = userName != null ? 'for $userName' : '';
    return _repository.sendMessage(
      messages: [
        {
          'role': 'user',
          'content':
              'Give me my morning briefing $greeting. Today is ${DateTime.now().toLocal()}.',
        },
      ],
      systemPrompt: PersonaPrompts.morningBriefingPrompt,
      maxTokens: 512,
    );
  }
}
