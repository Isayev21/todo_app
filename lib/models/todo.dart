import 'package:todo_list_app/enums/task_priority.dart';

class Todo {
  //DateTime.now().millisecondsSinceEpoch
  int id;
  String title;
  String description;
  bool isChecked;
  TaskPriority taskPriority;

  Todo(
      {required this.id,
      required this.title,
      required this.description,
      required this.taskPriority,
      this.isChecked = false});

  String get todoTitle {
    return title;
  }

  @override
  toString() => 'priority: $taskPriority';
}
