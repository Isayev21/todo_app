import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/providers/todo_provider.dart';
import 'package:todo_list_app/widgets/appbar.dart';

class CompletedTodos extends StatelessWidget {
  const CompletedTodos({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoProvider>(context);
    final todos = provider.completedTodos;

    return Scaffold(
      appBar: appBar(
        const Text('Completed tasks'),
        [],
      ),
      body: todos.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SvgPicture.asset(
                    'assets/images/delayed.svg',
                    height: 200,
                  ),
                ),
                Text(
                  'No Completed Tasks',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            )
          : Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return Dismissible(
                    key: Key(todo.id.toString()),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      provider.removeTodo(todo);
                      provider.deleteUndosnackBarUtil(
                          context, todo, 'Task Removed', index);
                    },
                    background: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Card(
                      // key: ,
                      elevation: 1,
                      child: ListTile(
                        leading: Checkbox(
                          value: todo.isChecked,
                          onChanged: (value) {
                            //adding to the completed screen
                            provider.toggleTodoStatus(todo);
                            provider.toggleUndosnackBarUtil(
                                context, todo, 'Added to the list', index);
                          },
                        ),
                        title: Text(todo.todoTitle),
                        subtitle: Text(todo.description),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
