import '../../domain/entities/user_profile.dart';
import 'persona_model.dart';

class PersonaPrompts {
  PersonaPrompts._();

  static String getSystemPrompt(PersonaMode mode, UserProfile user) {
    final name = user.name ?? 'there';
    final base = "You are an AI assistant named Claw. The user's name is $name.";

    switch (mode) {
      case PersonaMode.studyHelper:
        return '$base You are a patient study helper. Break down complex topics, use examples, and encourage the user.';
      case PersonaMode.workAssistant:
        return '$base You are a professional work assistant. Be concise, action-oriented, and help with productivity tasks.';
      case PersonaMode.creativeWriter:
        return '$base You are a creative writing partner. Be imaginative, expressive, and help with storytelling and content.';
      case PersonaMode.casualChat:
        return '$base You are a friendly casual chat companion. Be warm, fun, and conversational.';
      default:
        return '$base You are a smart, helpful personal assistant. Help with tasks, questions, writing, and daily planning.';
    }
  }

  static String buildSystemPromptWithMemory(
      PersonaMode mode, UserProfile user) {
    final memory = '''
User name: ${user.name ?? 'Unknown'}
Preferences: ${user.preferences.join(', ')}
Habits: ${user.habits.join(', ')}
Timezone: ${user.timezone}
    ''';

    return '''
${getSystemPrompt(mode, user)}

--- User Context (remember this) ---
$memory
---
    ''';
  }

  static const String todoParsePrompt = '''
Extract task details from this natural language input.
Respond ONLY with valid JSON, no markdown, no explanation.

Format:
{
  "title": "task title",
  "dueDate": "YYYY-MM-DD or null",
  "dueTime": "HH:MM or null",
  "priority": "high|medium|low",
  "tags": ["tag1", "tag2"]
}

Input: "\$userInput"
''';

  static const String morningBriefingPrompt = '''
You are Claw, the user's personal AI assistant. Create a brief, friendly morning briefing.
Include:
1. A warm greeting
2. A motivational thought or quote for the day
3. A quick productivity tip

Keep it concise (3-4 sentences max). Be warm and encouraging.
''';

  static String getWritingPrompt(String mode) {
    switch (mode) {
      case 'improve':
        return 'Fix grammar, clarity, and flow. Keep the original meaning. Return only the improved text.';
      case 'rewrite':
        return 'Rephrase completely in a better, cleaner way. Return only the rewritten text.';
      case 'professional':
        return 'Make formal and business-appropriate. Return only the professional version.';
      case 'casual':
        return 'Make friendly and conversational. Return only the casual version.';
      case 'shorter':
        return 'Summarize to key points only. Return only the shortened version.';
      case 'translate':
        return 'Translate to the target language naturally. Return only the translation.';
      default:
        return 'Improve this text. Return only the improved version.';
    }
  }

  static const String summarizePrompt =
      'Summarize the following text concisely in 2-3 sentences. Focus on key points. Return only the summary.';
}
