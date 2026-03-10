import '../../core/errors/result.dart';
import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

class AddTodoUseCase {
  final TodoRepository _repository;

  AddTodoUseCase({required TodoRepository repository})
      : _repository = repository;

  Future<Result<void>> call(Todo todo) {
    return _repository.addTodo(todo);
  }

  Future<Result<Map<String, dynamic>>> parseNaturalLanguage(String input) {
    return _repository.parseTodoFromNaturalLanguage(input);
  }
}
