import 'package:flutter/material.dart';
import 'package:todo_list_app/providers/todo_provider.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/screens/intro_screen.dart';

void main() => runApp(
      const MyApp(),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TodoProvider>(
      create: (BuildContext context) {
        return TodoProvider();
      },
      child: MaterialApp(
        theme: ThemeData().copyWith(
          appBarTheme: const AppBarTheme(color: Colors.blueGrey),
          useMaterial3: true,
        ),
        title: 'Material App',
        home: const IntroScreen(),
      ),
    );
  }
}
