enum TodoPriority { high, medium, low }

class Todo {
  final String id;
  final String title;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? dueDate;
  final String? dueTime;
  final TodoPriority priority;
  final List<String> tags;

  const Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
    required this.createdAt,
    this.dueDate,
    this.dueTime,
    this.priority = TodoPriority.medium,
    this.tags = const [],
  });

  Todo copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? dueDate,
    String? dueTime,
    TodoPriority? priority,
    List<String>? tags,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      dueTime: dueTime ?? this.dueTime,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
    );
  }
}
