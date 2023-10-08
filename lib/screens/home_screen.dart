import 'package:flutter/material.dart';
import 'package:todo_list_app/providers/todo_provider.dart';
import 'package:todo_list_app/screens/completed_todos_screen.dart';
import 'package:todo_list_app/screens/todos_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var currentTab = [const TodosScreen(), const CompletedTodos()];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoProvider>(context);

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        indicatorColor: Colors.grey,
        selectedIndex: provider.getCurrentPageIndex,
        onDestinationSelected: (value) {
          provider.setCurrentPageIndex = value;
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.fact_check_rounded),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.done_all_rounded),
            label: 'Completed',
          ),
        ],
      ),
      body: currentTab[provider.getCurrentPageIndex],
    );
  }
}
