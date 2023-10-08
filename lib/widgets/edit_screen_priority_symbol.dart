import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/enums/task_priority.dart';
import 'package:todo_list_app/models/todo.dart';
import 'package:todo_list_app/providers/todo_provider.dart';

Widget editpriorityLevelSymbol(BuildContext context, Todo todo, int index) {
  final todoProvider = Provider.of<TodoProvider>(context, listen: false);

  return (todoProvider.todos[index].taskPriority == TaskPriority.none)
      ? const Text('')
      : (todoProvider.todos[index].taskPriority == TaskPriority.low)
          ? const Text('!', style: TextStyle(fontSize: 25))
          : (todoProvider.todos[index].taskPriority == TaskPriority.medium)
              ? const Text('!!', style: TextStyle(fontSize: 25))
              : (todoProvider.todos[index].taskPriority == TaskPriority.high)
                  ? const Text('!!!', style: TextStyle(fontSize: 25))
                  : const Text('');
}