import 'package:flutter/material.dart';
import 'package:todo_list_app/enums/task_priority.dart';
import 'package:todo_list_app/models/todo.dart';

class TodoProvider extends ChangeNotifier {
  final List<Todo> _todoList = [];
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  int _currentPageIndex = 0;
  TaskPriority selectedPriority = TaskPriority.none;
  bool isChangingPriority = false;
  bool isSortedPressed = false;

  int get getCurrentPageIndex => _currentPageIndex;

  set setCurrentPageIndex(int index) {
    _currentPageIndex = index;
    notifyListeners();
  }

  TextEditingController get titleController => _titleController;
  TextEditingController get descController => _descriptionController;

  List<Todo> get todos =>
      _todoList.where((todo) => todo.isChecked == false).toList();

  List<Todo> get completedTodos =>
      _todoList.where((todo) => todo.isChecked == true).toList();

  int get todoListLength {
    return _todoList.length;
  }

  void addTodo() {
    if (_titleController.text.trim().isEmpty) {
      return;
    }
    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch,
      title: _titleController.text,
      description: _descriptionController.text,
      taskPriority: selectedPriority,
    );
    _todoList.add(newTodo);
    _titleController.clear();
    _descriptionController.clear();
    selectedPriority = TaskPriority.none;
    isChangingPriority = false;
    notifyListeners();
  }

  void removeTodo(Todo todo) {
    final todoIndex = _todoList.indexOf(todo);
    _todoList.removeAt(todoIndex);
    notifyListeners();
  }

  void updatePriority(TaskPriority newPriority) {
    selectedPriority = newPriority;
    isChangingPriority = true;

    notifyListeners();
  }

  void editToDoItem(Todo todo) {
    todo.title = _titleController.text;
    todo.description = _descriptionController.text;
    todo.taskPriority = selectedPriority;
    notifyListeners();
  }

  void sortTodos() {
    if (isSortedPressed) {
      _todoList.sort(
        (a, b) => b.taskPriority.index.compareTo(a.taskPriority.index),
      );
    } else {
      _todoList.sort(
        (a, b) => a.taskPriority.index.compareTo(b.taskPriority.index),
      );
    }
    isSortedPressed = !isSortedPressed;
    notifyListeners();
  }

  Widget priorityLevelSymbol(int index) {
    return (_todoList[index].taskPriority == TaskPriority.none)
        ? const Text('')
        : (_todoList[index].taskPriority == TaskPriority.low)
            ? const Text('!', style: TextStyle(fontSize: 25))
            : (_todoList[index].taskPriority == TaskPriority.medium)
                ? const Text('!!', style: TextStyle(fontSize: 25))
                : (_todoList[index].taskPriority == TaskPriority.high)
                    ? const Text('!!!', style: TextStyle(fontSize: 25))
                    : const Text('');
  }

  Widget editPriorityLevelSymbol(TaskPriority priority) {
    return (priority == TaskPriority.none)
        ? const Text('')
        : (priority == TaskPriority.low)
            ? const Text('!', style: TextStyle(fontSize: 25))
            : (priority == TaskPriority.medium)
                ? const Text('!!', style: TextStyle(fontSize: 25))
                : (priority == TaskPriority.high)
                    ? const Text('!!!', style: TextStyle(fontSize: 25))
                    : const Text('');
  }

  bool toggleTodoStatus(Todo todo) {
    todo.isChecked = !todo.isChecked;
    notifyListeners();
    return todo.isChecked;
  }

  void clearFormFields() {
    _titleController.clear();
    _descriptionController.clear();
  }

  void toggleUndosnackBarUtil(
      BuildContext context, Todo todo, String snackTitle, int index) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(snackTitle),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            toggleTodoStatus(todo);
          },
        ),
      ),
    );
    notifyListeners();
  }

  void deleteUndosnackBarUtil(
      BuildContext context, Todo todo, String snackTitle, int index) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(snackTitle),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            _todoList.insert(index, todo);
            notifyListeners();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
