import 'package:flutter/material.dart';
import 'package:todo_list_app/models/todo.dart';
import 'package:todo_list_app/providers/todo_provider.dart';

Widget getFloationActionButton({
    required List<Todo> todos,
    required TodoProvider provider,
  }) {
    return todos.length <= 1
        ? Container()
        : FloatingActionButton(
            backgroundColor: Colors.blueGrey,
            child: const Icon(
              Icons.filter_list_alt,
              size: 30,
              semanticLabel: 'Filter list',
            ),
            onPressed: () {
              provider.sortTodos();
            },
          );
  }