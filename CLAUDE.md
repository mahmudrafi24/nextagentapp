# CLAUDE.md — OpenClaw AI Assistant (Flutter MVP)

> This file is the single source of truth for Claude Code when working on this project.
> Read this entire file before writing any code.

---

## 📱 Project Overview

**App Name:** OpenClaw AI Assistant  
**Platform:** Flutter (iOS + Android)  
**State Management:** GetX  
**Architecture:** Clean Architecture  
**API:** OpenClaw API (Claude-compatible endpoint)  
**Stage:** MVP — Frontend only, free for users  
**Post-MVP plan:** Monetization via subscription (freemium model)

---

## 🎯 MVP Feature Set

| # | Feature | Priority |
|---|---------|----------|
| 1 | Smart Daily Assistant (morning briefing, weather, tasks) | P0 |
| 2 | Ask Anything — quick AI chat input | P0 |
| 3 | AI-Powered To-Do List (natural language) | P0 |
| 4 | AI Writing Assistant (rewrite, improve, translate) | P0 |
| 5 | Conversation Memory (name, prefs, habits) | P0 |
| 6 | Quick Knowledge & Research (explain, summarize) | P1 |
| 7 | Custom AI Personas / Modes | P1 |
| 8 | Smart Note-Taking with AI summarization | P1 |
| 9 | Daily Journal with AI reflection prompts | P2 |
| 10 | Voice-to-Text input | P2 |
| 11 | Offline-ready local AI responses | P2 |

---

## 🏗️ Clean Architecture Structure

```
lib/
├── main.dart
├── app/
│   ├── app.dart                        # MaterialApp + GetMaterialApp config
│   └── routes/
│       ├── app_pages.dart              # All GetX routes
│       └── app_routes.dart             # Route name constants
│
├── core/
│   ├── constants/
│   │   ├── api_constants.dart          # OpenClaw base URL, endpoints
│   │   ├── app_constants.dart          # App-wide constants
│   │   └── storage_keys.dart           # GetStorage key constants
│   ├── errors/
│   │   ├── exceptions.dart             # Custom exceptions
│   │   └── failures.dart               # Failure sealed classes
│   ├── network/
│   │   ├── dio_client.dart             # Dio HTTP client setup
│   │   └── network_info.dart           # Connectivity checker
│   ├── theme/
│   │   ├── app_theme.dart              # Light + Dark theme
│   │   ├── app_colors.dart             # Color palette
│   │   └── app_text_styles.dart        # Typography
│   ├── utils/
│   │   ├── date_utils.dart
│   │   ├── string_utils.dart
│   │   └── validators.dart
│   └── widgets/                        # Shared reusable widgets
│       ├── app_button.dart
│       ├── app_text_field.dart
│       ├── loading_overlay.dart
│       └── error_snackbar.dart
│
├── data/
│   ├── datasources/
│   │   ├── local/
│   │   │   ├── storage_service.dart    # GetStorage wrapper
│   │   │   └── hive_service.dart       # Hive for chat history / notes
│   │   └── remote/
│   │       └── openclaw_api_service.dart  # All API calls
│   ├── models/
│   │   ├── message_model.dart
│   │   ├── todo_model.dart
│   │   ├── note_model.dart
│   │   ├── persona_model.dart
│   │   └── user_profile_model.dart
│   └── repositories/
│       ├── chat_repository_impl.dart
│       ├── todo_repository_impl.dart
│       └── notes_repository_impl.dart
│
├── domain/
│   ├── entities/
│   │   ├── message.dart
│   │   ├── todo.dart
│   │   ├── note.dart
│   │   └── user_profile.dart
│   ├── repositories/                   # Abstract interfaces
│   │   ├── chat_repository.dart
│   │   ├── todo_repository.dart
│   │   └── notes_repository.dart
│   └── usecases/
│       ├── send_message_usecase.dart
│       ├── get_chat_history_usecase.dart
│       ├── add_todo_usecase.dart
│       ├── improve_text_usecase.dart
│       └── get_morning_briefing_usecase.dart
│
└── presentation/
    ├── bindings/                        # GetX bindings (DI)
    │   ├── home_binding.dart
    │   ├── chat_binding.dart
    │   ├── todo_binding.dart
    │   └── writing_binding.dart
    ├── controllers/                     # GetX controllers
    │   ├── home_controller.dart
    │   ├── chat_controller.dart
    │   ├── todo_controller.dart
    │   ├── writing_controller.dart
    │   ├── persona_controller.dart
    │   └── settings_controller.dart
    └── pages/
        ├── splash/
        │   └── splash_page.dart
        ├── onboarding/
        │   └── onboarding_page.dart
        ├── home/
        │   ├── home_page.dart
        │   └── widgets/
        │       ├── morning_briefing_card.dart
        │       ├── quick_actions_row.dart
        │       └── recent_chats_list.dart
        ├── chat/
        │   ├── chat_page.dart
        │   └── widgets/
        │       ├── message_bubble.dart
        │       ├── chat_input_bar.dart
        │       └── typing_indicator.dart
        ├── todo/
        │   ├── todo_page.dart
        │   └── widgets/
        │       └── todo_item_card.dart
        ├── writing/
        │   ├── writing_page.dart
        │   └── widgets/
        │       └── mode_selector_chips.dart
        ├── notes/
        │   └── notes_page.dart
        ├── personas/
        │   └── personas_page.dart
        └── settings/
            └── settings_page.dart
```

---

## 🔌 OpenClaw API Integration

### Base Configuration
```dart
// core/constants/api_constants.dart
class ApiConstants {
  static const String baseUrl = 'https://api.openclaw.ai/v1'; // Replace with actual
  static const String chatEndpoint = '/messages';
  static const String model = 'claude-sonnet-4-20250514'; // or openclaw equivalent
  static const int maxTokens = 1024;
  static const int timeoutSeconds = 30;
}
```

### API Service Pattern
```dart
// data/datasources/remote/openclaw_api_service.dart
class OpenClawApiService {
  final Dio _dio;

  Future<String> sendMessage({
    required List<Map<String, dynamic>> messages,
    String? systemPrompt,
    int maxTokens = 1024,
  }) async {
    final response = await _dio.post(
      ApiConstants.chatEndpoint,
      data: {
        'model': ApiConstants.model,
        'max_tokens': maxTokens,
        'system': systemPrompt,
        'messages': messages,
      },
    );
    return response.data['content'][0]['text'];
  }
}
```

### Request Message Format
```json
{
  "model": "claude-sonnet-4-20250514",
  "max_tokens": 1024,
  "system": "You are a helpful personal assistant...",
  "messages": [
    { "role": "user", "content": "Hello!" },
    { "role": "assistant", "content": "Hi! How can I help?" },
    { "role": "user", "content": "Remind me to call mom tomorrow" }
  ]
}
```

---

## 📦 Dependencies (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management & DI
  get: ^4.6.6                          # GetX for state, routes, DI
  get_storage: ^2.1.1                  # Lightweight key-value storage

  # Networking
  dio: ^5.4.0                          # HTTP client
  connectivity_plus: ^5.0.2           # Network status

  # Local Storage
  hive: ^2.2.3                         # Local DB for chat history
  hive_flutter: ^1.1.0
  path_provider: ^2.1.2

  # UI
  flutter_animate: ^4.5.0             # Smooth animations
  shimmer: ^3.0.0                      # Loading skeletons
  lottie: ^3.1.0                       # Lottie animations
  cached_network_image: ^3.3.1
  flutter_svg: ^2.0.10+1

  # Voice Input
  speech_to_text: ^6.6.0

  # Utilities
  intl: ^0.19.0                        # Date formatting
  uuid: ^4.3.3                         # Unique IDs
  share_plus: ^7.2.2                   # Share content
  url_launcher: ^6.2.4

  # Dev
  flutter_dotenv: ^5.1.0              # .env for API key management

dev_dependencies:
  flutter_test:
    sdk: flutter
  hive_generator: ^2.0.1
  build_runner: ^2.4.8
  flutter_lints: ^3.0.0
```

---

## 🎨 Design System

### Color Palette
```dart
// core/theme/app_colors.dart
class AppColors {
  // Primary
  static const Color primary = Color(0xFF6C63FF);       // Purple-blue
  static const Color primaryLight = Color(0xFF9C95FF);
  static const Color primaryDark = Color(0xFF3D35CC);

  // Background (Dark default)
  static const Color bgDark = Color(0xFF0D1117);         // Same as your GenAI Labs brand
  static const Color bgCard = Color(0xFF161B22);
  static const Color bgSurface = Color(0xFF21262D);

  // Accent
  static const Color accent = Color(0xFF00D4AA);         // Teal — your brand color
  static const Color accentWarm = Color(0xFFFF6B6B);     // For warnings/energy

  // Text
  static const Color textPrimary = Color(0xFFE6EDF3);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color textMuted = Color(0xFF484F58);

  // Semantic
  static const Color success = Color(0xFF3FB950);
  static const Color warning = Color(0xFFD29922);
  static const Color error = Color(0xFFF85149);
}
```

### Typography
```dart
class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -0.5,
  );
  static const TextStyle heading2 = TextStyle(
    fontSize: 22, fontWeight: FontWeight.w600,
  );
  static const TextStyle body = TextStyle(
    fontSize: 15, fontWeight: FontWeight.w400, height: 1.5,
  );
  static const TextStyle caption = TextStyle(
    fontSize: 12, fontWeight: FontWeight.w400,
  );
  static const TextStyle label = TextStyle(
    fontSize: 13, fontWeight: FontWeight.w500, letterSpacing: 0.2,
  );
}
```

---

## 🧠 AI Persona System

### Available Modes (MVP)
```dart
enum PersonaMode {
  assistant,      // Default — balanced helper
  studyHelper,    // Focused on learning, explains step-by-step
  workAssistant,  // Professional tone, productivity-focused
  creativeWriter, // Creative, expressive, storytelling
  casualChat,     // Friendly, relaxed, emoji-friendly
}
```

### System Prompt Templates
```dart
class PersonaPrompts {
  static String getSystemPrompt(PersonaMode mode, UserProfile user) {
    final name = user.name ?? 'there';
    final base = 'You are an AI assistant named Claw. The user\'s name is $name.';
    
    switch (mode) {
      case PersonaMode.studyHelper:
        return '$base You are a patient study helper. Break down complex topics, use examples, and encourage the user.';
      case PersonaMode.workAssistant:
        return '$base You are a professional work assistant. Be concise, action-oriented, and help with productivity tasks.';
      case PersonaMode.creativeWriter:
        return '$base You are a creative writing partner. Be imaginative, expressive, and help with storytelling and content.';
      case PersonaMode.casualChat:
        return '$base You are a friendly casual chat companion. Be warm, fun, and conversational. Use emojis occasionally.';
      default:
        return '$base You are a smart, helpful personal assistant. Help with tasks, questions, writing, and daily planning.';
    }
  }
}
```

---

## 🗄️ Local Storage Strategy

### GetStorage Keys (simple preferences)
```dart
class StorageKeys {
  static const String userName = 'user_name';
  static const String userPreferences = 'user_preferences';
  static const String currentPersona = 'current_persona';
  static const String onboardingComplete = 'onboarding_complete';
  static const String apiKey = 'openclaw_api_key';          // Stored securely
  static const String themeMode = 'theme_mode';
}
```

### Hive Boxes (structured data)
```dart
// Box names
const String chatHistoryBox = 'chat_history';
const String todosBox = 'todos';
const String notesBox = 'notes';
const String journalBox = 'journal_entries';
```

---

## 🔄 GetX Controller Pattern

### Standard Controller Template
```dart
class ChatController extends GetxController {
  final SendMessageUseCase _sendMessageUseCase;

  ChatController({required SendMessageUseCase sendMessageUseCase})
      : _sendMessageUseCase = sendMessageUseCase;

  // State
  final RxList<Message> messages = <Message>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString inputText = ''.obs;

  // TextEditingController
  final TextEditingController inputController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void onClose() {
    inputController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  Future<void> sendMessage() async {
    if (inputText.value.trim().isEmpty) return;

    final userMessage = Message(
      role: 'user',
      content: inputText.value.trim(),
      timestamp: DateTime.now(),
    );

    messages.add(userMessage);
    inputController.clear();
    inputText.value = '';
    isLoading.value = true;
    _scrollToBottom();

    final result = await _sendMessageUseCase(
      messages: messages.map((m) => m.toMap()).toList(),
    );

    result.fold(
      (failure) => errorMessage.value = failure.message,
      (response) {
        messages.add(Message(
          role: 'assistant',
          content: response,
          timestamp: DateTime.now(),
        ));
        _scrollToBottom();
      },
    );

    isLoading.value = false;
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
```

---

## 🧭 Navigation & Routes

```dart
// app/routes/app_routes.dart
abstract class AppRoutes {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const chat = '/chat';
  static const todo = '/todo';
  static const writing = '/writing';
  static const notes = '/notes';
  static const personas = '/personas';
  static const settings = '/settings';
  static const journal = '/journal';
}
```

```dart
// app/routes/app_pages.dart
class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.splash, page: () => SplashPage(), binding: SplashBinding()),
    GetPage(name: AppRoutes.home, page: () => HomePage(), binding: HomeBinding()),
    GetPage(name: AppRoutes.chat, page: () => ChatPage(), binding: ChatBinding()),
    GetPage(name: AppRoutes.todo, page: () => TodoPage(), binding: TodoBinding()),
    GetPage(name: AppRoutes.writing, page: () => WritingPage(), binding: WritingBinding()),
    // ...
  ];
}
```

---

## 🏠 Home Page Layout

The Home page is the central hub with bottom navigation:

```
┌─────────────────────────────────┐
│  Good morning, [Name] 👋        │
│  [Morning Briefing Card]         │
│  ─────────────────────────────  │
│  Quick Actions                   │
│  [Ask AI] [Todo] [Write] [Note] │
│  ─────────────────────────────  │
│  Recent Chats                    │
│  [Chat item 1]                   │
│  [Chat item 2]                   │
├─────────────────────────────────┤
│ 🏠 Home  💬 Chat  ✅ Todo  ✏️ More │
└─────────────────────────────────┘
```

Bottom Nav Tabs: Home, Chat, Todo, Writing, Settings

---

## 📋 Todo Natural Language Parsing

When user inputs a todo in natural language, send to OpenClaw:

```dart
const String todoParsePrompt = '''
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

Input: "$userInput"
''';
```

---

## ✍️ Writing Assistant Modes

| Mode | System Prompt Focus |
|------|-------------------|
| Improve | Fix grammar, clarity, flow. Keep original meaning. |
| Rewrite | Rephrase completely in a better, cleaner way. |
| Professional | Make formal and business-appropriate. |
| Casual | Make friendly and conversational. |
| Shorter | Summarize to key points only. |
| Translate | Translate to target language naturally. |

---

## 🔒 API Key Management

```dart
// Stored in GetStorage (for MVP — upgrade to flutter_secure_storage post-MVP)
class ApiKeyService {
  static const _key = StorageKeys.apiKey;
  final GetStorage _storage = GetStorage();

  void saveApiKey(String key) => _storage.write(_key, key);
  String? getApiKey() => _storage.read<String>(_key);
  bool get hasApiKey => getApiKey() != null && getApiKey()!.isNotEmpty;
}
```

---

## 🌐 Network Layer (Dio)

```dart
// core/network/dio_client.dart
class DioClient {
  static Dio createDio(String apiKey) {
    final dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': apiKey,               // OpenClaw API key header
        'anthropic-version': '2023-06-01',  // Adjust per OpenClaw docs
      },
    ));

    dio.interceptors.addAll([
      LogInterceptor(requestBody: true, responseBody: true),
      // RetryInterceptor for auto-retry on network errors
    ]);

    return dio;
  }
}
```

---

## 🗣️ Conversation Memory

To simulate memory across sessions, inject stored context into each system prompt:

```dart
String buildSystemPromptWithMemory(PersonaMode mode, UserProfile user) {
  final memory = '''
User name: ${user.name ?? 'Unknown'}
Preferences: ${user.preferences.join(', ')}
Habits: ${user.habits.join(', ')}
Timezone: ${user.timezone}
  ''';

  return '''
${PersonaPrompts.getSystemPrompt(mode, user)}

--- User Context (remember this) ---
$memory
---
  ''';
}
```

---

## 📐 Coding Standards

### Naming Conventions
- Files: `snake_case.dart`
- Classes: `PascalCase`
- Variables/methods: `camelCase`
- Constants: `camelCase` (in const classes) or `SCREAMING_SNAKE` for global constants
- GetX controllers: always suffix `Controller`
- Bindings: always suffix `Binding`
- Use cases: always suffix `UseCase`

### File Rules
- One class per file (exceptions: small related data classes)
- Max ~200 lines per file — split if longer
- All strings in constants files, never hardcoded in widgets
- No business logic in widgets — all in controllers

### GetX Rules
- Use `Obx()` for reactive UI, never `GetBuilder` unless needed for performance
- Use `Get.find<Controller>()` sparingly — prefer binding injection
- Always dispose TextEditingControllers and ScrollControllers in `onClose()`
- Use `Get.snackbar()` for user-facing messages
- Use `Get.dialog()` for confirmations

### API Calls
- Always wrap in try/catch
- Return `Either<Failure, T>` from repositories (use `dartz` or simple custom sealed class)
- Never call API directly from controllers — always through use cases
- Show loading state before API call, hide in finally block

---

## 🧪 Error Handling Pattern

```dart
// domain/errors/failures.dart
sealed class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

class ApiFailure extends Failure {
  final int? statusCode;
  const ApiFailure(super.message, {this.statusCode});
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local storage error']);
}
```

---

## 🚀 MVP Screens Checklist

- [ ] `SplashPage` — Logo + init check (onboarding done? → route)
- [ ] `OnboardingPage` — Name input + persona selection + API key entry
- [ ] `HomePage` — Morning briefing card + quick actions + recent chats
- [ ] `ChatPage` — Full conversation UI with streaming-like display
- [ ] `TodoPage` — Natural language todo input + list with AI parsing
- [ ] `WritingPage` — Text input + mode selector + AI output
- [ ] `NotesPage` — Note list + AI summarize button
- [ ] `PersonasPage` — Grid of persona cards + custom persona creation
- [ ] `SettingsPage` — Theme, API key, clear data, about

---

## ⚙️ Environment Setup

```
# .env (add to .gitignore!)
OPENCLAW_API_KEY=your_api_key_here
OPENCLAW_BASE_URL=https://api.openclaw.ai/v1
```

Load via `flutter_dotenv`:
```dart
await dotenv.load(fileName: '.env');
final apiKey = dotenv.env['OPENCLAW_API_KEY']!;
```

---

## 🔮 Post-MVP (Do NOT build yet)

- Stripe/RevenueCat subscription paywall
- Firebase Auth + Firestore sync
- Push notifications (reminders)
- Widget (home screen)
- Apple Watch companion
- Web version
- PDF/article URL summarization via web scraping

---

## ⚠️ Important Notes for Claude Code

1. **Frontend only** — No backend, no auth server in MVP
2. **API key stored locally** — User enters it in onboarding
3. **Dark theme default** — Light theme optional toggle in settings
4. **OpenClaw = Claude API compatible** — Same message format as Anthropic API
5. **GetX only** — Do NOT use Provider, Riverpod, or BLoC anywhere
6. **No Firebase in MVP** — All data is local (GetStorage + Hive)
7. **Streaming optional** — Implement non-streaming first, add streaming in v1.1
8. **English first** — i18n architecture ready but only English strings for MVP
9. **Null safety required** — All code must be fully null-safe
10. **Min SDK: Flutter 3.19+, Dart 3.3+**
