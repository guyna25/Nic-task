import 'package:flutter/material.dart';
import 'package:nic_task/screens/todo_screen.dart';
import 'package:provider/provider.dart';
import 'screens/todo_detail_screen.dart';
import './state/todo_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TodoModel(),
      child: TodoListApp(),
    ),
  );
}

class TodoListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo list',
      initialRoute: TodoScreen.routeName,
      routes: {
        TodoScreen.routeName: (context) => TodoScreen(),
        TodoDetailScreen.routeName: (context) => TodoDetailScreen(),
      },
    );
  }
}
