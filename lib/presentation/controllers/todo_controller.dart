import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/todo.dart';
import '../../domain/usecases/add_todo_usecase.dart';
import '../../domain/repositories/todo_repository.dart';
import '../../core/widgets/error_snackbar.dart';

class TodoController extends GetxController {
  final AddTodoUseCase _addTodoUseCase;
  final TodoRepository _todoRepository;

  TodoController({
    required AddTodoUseCase addTodoUseCase,
    required TodoRepository todoRepository,
  })  : _addTodoUseCase = addTodoUseCase,
        _todoRepository = todoRepository;

  final RxList<Todo> todos = <Todo>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isParsing = false.obs;
  final RxString inputText = ''.obs;

  final TextEditingController inputController = TextEditingController();
  final _uuid = const Uuid();

  @override
  void onInit() {
    super.onInit();
    loadTodos();
  }

  @override
  void onClose() {
    inputController.dispose();
    super.onClose();
  }

  Future<void> loadTodos() async {
    isLoading.value = true;
    final result = await _todoRepository.getAllTodos();
    result.fold(
      (failure) => showErrorSnackbar(failure.message),
      (data) => todos.assignAll(data),
    );
    isLoading.value = false;
  }

  Future<void> addTodoFromNaturalLanguage() async {
    if (inputText.value.trim().isEmpty) return;

    isParsing.value = true;
    final input = inputText.value.trim();
    inputController.clear();
    inputText.value = '';

    final parseResult = await _addTodoUseCase.parseNaturalLanguage(input);

    parseResult.fold(
      (failure) async {
        // Fallback: create simple todo
        final todo = Todo(
          id: _uuid.v4(),
          title: input,
          createdAt: DateTime.now(),
        );
        await _saveTodo(todo);
      },
      (parsed) async {
        final todo = Todo(
          id: _uuid.v4(),
          title: parsed['title'] as String? ?? input,
          createdAt: DateTime.now(),
          dueDate: parsed['dueDate'] != null
              ? DateTime.tryParse(parsed['dueDate'] as String)
              : null,
          dueTime: parsed['dueTime'] as String?,
          priority: TodoPriority.values.firstWhere(
            (e) => e.name == (parsed['priority'] as String? ?? 'medium'),
            orElse: () => TodoPriority.medium,
          ),
          tags: (parsed['tags'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [],
        );
        await _saveTodo(todo);
      },
    );

    isParsing.value = false;
  }

  Future<void> _saveTodo(Todo todo) async {
    final result = await _addTodoUseCase(todo);
    result.fold(
      (failure) => showErrorSnackbar(failure.message),
      (_) {
        todos.insert(0, todo);
        showSuccessSnackbar('Todo added!');
      },
    );
  }

  Future<void> toggleTodo(String id) async {
    final index = todos.indexWhere((t) => t.id == id);
    if (index == -1) return;

    final todo = todos[index];
    final updated = todo.copyWith(isCompleted: !todo.isCompleted);
    final result = await _todoRepository.updateTodo(updated);

    result.fold(
      (failure) => showErrorSnackbar(failure.message),
      (_) => todos[index] = updated,
    );
  }

  Future<void> deleteTodo(String id) async {
    final result = await _todoRepository.deleteTodo(id);
    result.fold(
      (failure) => showErrorSnackbar(failure.message),
      (_) => todos.removeWhere((t) => t.id == id),
    );
  }

  List<Todo> get activeTodos =>
      todos.where((t) => !t.isCompleted).toList();

  List<Todo> get completedTodos =>
      todos.where((t) => t.isCompleted).toList();
}
