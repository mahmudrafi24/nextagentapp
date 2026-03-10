import 'package:get/get.dart';
import '../../domain/repositories/todo_repository.dart';
import '../../domain/usecases/add_todo_usecase.dart';
import '../controllers/todo_controller.dart';

class TodoBinding extends Bindings {
  @override
  void dependencies() {
    final todoRepo = Get.find<TodoRepository>();

    Get.lazyPut<TodoController>(() => TodoController(
          addTodoUseCase: AddTodoUseCase(repository: todoRepo),
          todoRepository: todoRepo,
        ));
  }
}
