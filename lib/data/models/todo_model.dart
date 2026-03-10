import '../../domain/entities/todo.dart';

class TodoModel extends Todo {
  const TodoModel({
    required super.id,
    required super.title,
    super.isCompleted,
    required super.createdAt,
    super.dueDate,
    super.dueTime,
    super.priority,
    super.tags,
  });

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'] as String,
      title: map['title'] as String,
      isCompleted: map['isCompleted'] as bool? ?? false,
      createdAt: DateTime.parse(map['createdAt'] as String),
      dueDate: map['dueDate'] != null
          ? DateTime.parse(map['dueDate'] as String)
          : null,
      dueTime: map['dueTime'] as String?,
      priority: TodoPriority.values.firstWhere(
        (e) => e.name == (map['priority'] as String? ?? 'medium'),
        orElse: () => TodoPriority.medium,
      ),
      tags: (map['tags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'isCompleted': isCompleted,
        'createdAt': createdAt.toIso8601String(),
        'dueDate': dueDate?.toIso8601String(),
        'dueTime': dueTime,
        'priority': priority.name,
        'tags': tags,
      };

  factory TodoModel.fromEntity(Todo todo) {
    return TodoModel(
      id: todo.id,
      title: todo.title,
      isCompleted: todo.isCompleted,
      createdAt: todo.createdAt,
      dueDate: todo.dueDate,
      dueTime: todo.dueTime,
      priority: todo.priority,
      tags: todo.tags,
    );
  }
}
