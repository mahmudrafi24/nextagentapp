import 'package:get/get.dart';
import 'app_routes.dart';
import '../../presentation/bindings/home_binding.dart';
import '../../presentation/bindings/chat_binding.dart';
import '../../presentation/bindings/todo_binding.dart';
import '../../presentation/bindings/writing_binding.dart';
import '../../presentation/pages/splash/splash_page.dart';
import '../../presentation/pages/onboarding/onboarding_page.dart';
import '../../presentation/pages/home/home_page.dart';
import '../../presentation/pages/chat/chat_page.dart';
import '../../presentation/pages/todo/todo_page.dart';
import '../../presentation/pages/writing/writing_page.dart';
import '../../presentation/pages/notes/notes_page.dart';
import '../../presentation/pages/personas/personas_page.dart';
import '../../presentation/pages/settings/settings_page.dart';

class AppPages {
  AppPages._();

  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingPage(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.chat,
      page: () => const ChatPage(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: AppRoutes.todo,
      page: () => const TodoPage(),
      binding: TodoBinding(),
    ),
    GetPage(
      name: AppRoutes.writing,
      page: () => const WritingPage(),
      binding: WritingBinding(),
    ),
    GetPage(
      name: AppRoutes.notes,
      page: () => const NotesPage(),
    ),
    GetPage(
      name: AppRoutes.personas,
      page: () => const PersonasPage(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsPage(),
    ),
  ];
}
