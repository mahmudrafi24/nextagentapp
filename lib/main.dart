import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'app.dart';
import 'app/di/initial_binding.dart';
import 'data/datasources/local/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Init local storage
  await GetStorage.init();
  final hiveService = HiveService();
  await hiveService.init();

  // System UI
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  // Init DI
  InitialBinding().dependencies();

  runApp(const OpenClawApp());
}
