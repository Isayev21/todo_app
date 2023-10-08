import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/enums/task_priority.dart';
import 'package:todo_list_app/models/todo.dart';
import 'package:todo_list_app/providers/todo_provider.dart';
import 'package:todo_list_app/widgets/appbar.dart';
import 'package:todo_list_app/widgets/empty_content_view.dart';
import 'package:todo_list_app/widgets/floating_action_button.dart';
import 'package:todo_list_app/widgets/icon_button.dart';
import 'package:todo_list_app/widgets/text_form_field.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({super.key});

  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  final String _appBarTitle = 'Your Tasks';

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    final todos = todoProvider.todos;

    return Scaffold(
      floatingActionButton:
          getFloationActionButton(todos: todos, provider: todoProvider),
      appBar: appBar(
        Text(_appBarTitle),
        [
          const SizedBox(
            width: 10,
          ),
          iconButton(
              onPressed: () {
                modalBottomSheet(
                    context: context,
                    onPressed: () {
                      todoProvider.addTodo();
                      todoProvider.clearFormFields();
                      Navigator.of(context).pop();
                    });
              },
              icon: const Icon(CupertinoIcons.add))
        ],
      ),
      body: todos.isEmpty
          ? emptyContentView(
              context: context,
              image: SvgPicture.asset('assets/images/no_task_found.svg'),
              content: 'No tasks found. Try to add some!')
          : listView(todos, todoProvider),
    );
  }

  Widget listView(List<Todo> todos, TodoProvider todoProvider) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return slidable(todo, index, context);
        },
      ),
    );
  }

  Widget slidable(Todo todo, int index, BuildContext context) {
    return Consumer<TodoProvider>(
      builder: (context, value, child) {
        return Slidable(
          startActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) {
                  editModalBottomSheet(context, todo, index);
                },
                icon: Icons.edit,
                backgroundColor: Colors.green,
                label: 'Edit',
              ),
            ],
          ),
          endActionPane: ActionPane(motion: const ScrollMotion(), children: [
            SlidableAction(
              onPressed: (context) {
                value.removeTodo(todo);
                value.deleteUndosnackBarUtil(
                    context, todo, 'Task removed', index);
              },
              backgroundColor: Colors.red,
              icon: Icons.delete,
              label: 'Delete',
            )
          ]),
          child: getTaskCard(todo, context, index),
        );
      },
    );
  }

  void modalBottomSheet(
      {required BuildContext context, required Function() onPressed}) {
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Consumer<TodoProvider>(
            builder: (context, provider, child) {
              if (!provider.isChangingPriority) {
                provider.selectedPriority = TaskPriority.none;
                provider.titleController.clear();
                provider.descController.clear();
              }

              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                    child: Text(
                      'Add Task',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  getTextFormField(
                      hintText: 'What would you like to do?',
                      controller: provider.titleController,
                      maxLength: 50),
                  const SizedBox(
                    height: 10,
                  ),
                  getTextFormField(
                    hintText: 'Description',
                    controller: provider.descController,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        'Remind: ',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      iconButton(
                        onPressed: () {},
                        icon: const Icon(
                          CupertinoIcons.alarm,
                          size: 30,
                        ),
                      ),
                      const Text(
                        'Priority: ',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      DropdownButton<TaskPriority>(
                        value: provider.selectedPriority,
                        items: TaskPriority.values.map((priority) {
                          return DropdownMenuItem(
                            value: priority,
                            child: Text(priority.name.toUpperCase()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          provider.updatePriority(value!);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: onPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey,
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }

  void editModalBottomSheet(BuildContext context, Todo todo, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<TodoProvider>(
            builder: (context, provider, child) {
              TaskPriority currentPriority = todo.taskPriority;
              provider.titleController.text = todo.title;
              provider.descController.text = todo.description;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: provider.titleController,
                    onChanged: (value) {
                      todo.title = value;
                    },
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  TextFormField(
                    controller: provider.descController,
                    onChanged: (value) => todo.description = value,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Remind: ',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      iconButton(
                        onPressed: () {},
                        icon: const Icon(
                          CupertinoIcons.alarm,
                          size: 30,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Priority: ',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Expanded(
                        child: DropdownButton<TaskPriority>(
                          value: currentPriority,
                          items: TaskPriority.values.map((priority) {
                            return DropdownMenuItem(
                              value: priority,
                              child: Text(
                                priority.name.toUpperCase(),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value == null) {
                              return;
                            }
                            provider.editPriorityLevelSymbol(value);
                            provider.updatePriority(value);
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey),
                    onPressed: () {
                      provider.editToDoItem(todo);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget getTaskCard(Todo todo, BuildContext context, int index) {
    return Card(
      elevation: 1,
      child: Consumer<TodoProvider>(
        builder: (context, provider, child) {
          return ListTile(
            leading: Checkbox(
              value: todo.isChecked,
              onChanged: (value) {
                provider.toggleTodoStatus(todo);
                provider.toggleUndosnackBarUtil(
                    context, todo, 'Task Completed', index);
              },
            ),
            title: Row(
              children: [
                provider.priorityLevelSymbol(index),
                const SizedBox(width: 5),
                Text(todo.title),
              ],
            ),
            subtitle: Text(todo.description),
          );
        },
      ),
    );
  }
}
