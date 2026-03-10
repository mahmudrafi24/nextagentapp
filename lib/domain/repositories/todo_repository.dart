import '../../core/errors/result.dart';
import '../entities/todo.dart';

abstract class TodoRepository {
  Future<Result<List<Todo>>> getAllTodos();
  Future<Result<void>> addTodo(Todo todo);
  Future<Result<void>> updateTodo(Todo todo);
  Future<Result<void>> deleteTodo(String id);
  Future<Result<Map<String, dynamic>>> parseTodoFromNaturalLanguage(
      String input);
}
