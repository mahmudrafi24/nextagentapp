import 'dart:convert';

import '../../core/errors/exceptions.dart';
import '../../core/errors/result.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/local/hive_service.dart';
import '../datasources/remote/openclaw_api_service.dart';
import '../models/todo_model.dart';

class TodoRepositoryImpl implements TodoRepository {
  final HiveService _hiveService;
  final OpenClawApiService _apiService;
  final NetworkInfo _networkInfo;

  TodoRepositoryImpl({
    required HiveService hiveService,
    required OpenClawApiService apiService,
    required NetworkInfo networkInfo,
  })  : _hiveService = hiveService,
        _apiService = apiService,
        _networkInfo = networkInfo;

  @override
  Future<Result<List<Todo>>> getAllTodos() async {
    try {
      final maps = _hiveService.getAllTodos();
      final todos = maps.map((m) => TodoModel.fromMap(m) as Todo).toList();
      todos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return Success(todos);
    } catch (e) {
      return Error(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> addTodo(Todo todo) async {
    try {
      final model = TodoModel.fromEntity(todo);
      await _hiveService.saveTodo(model.toMap());
      return const Success(null);
    } catch (e) {
      return Error(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> updateTodo(Todo todo) async {
    try {
      final model = TodoModel.fromEntity(todo);
      await _hiveService.saveTodo(model.toMap());
      return const Success(null);
    } catch (e) {
      return Error(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteTodo(String id) async {
    try {
      await _hiveService.deleteTodo(id);
      return const Success(null);
    } catch (e) {
      return Error(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> parseTodoFromNaturalLanguage(
      String input) async {
    if (!await _networkInfo.isConnected) {
      return const Error(NetworkFailure());
    }

    try {
      final prompt = '''
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

Input: "$input"
''';

      final response = await _apiService.sendMessage(
        messages: [
          {'role': 'user', 'content': prompt},
        ],
        maxTokens: 256,
      );

      final parsed = jsonDecode(response) as Map<String, dynamic>;
      return Success(parsed);
    } on ServerException catch (e) {
      return Error(ApiFailure(e.message, statusCode: e.statusCode));
    } on FormatException {
      // If AI response isn't valid JSON, create a simple todo
      return Success({'title': input, 'priority': 'medium', 'tags': []});
    } catch (e) {
      return Error(ApiFailure(e.toString()));
    }
  }
}
