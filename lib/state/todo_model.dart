import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../model/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoModel extends ChangeNotifier {
  List<Todo> _todos = [
    // Todo(
    //     id: 0,
    //     title: "First Todo",
    //     description: "My first todo",
    //     dueDate: DateTime(
    //         DateTime.now().year, DateTime.now().month, DateTime.now().day)),
    // Todo(
    //     id: 1,
    //     title: "Second todo",
    //     description: "My second todo",
    //     dueDate: DateTime(
    //         DateTime.now().year, DateTime.now().month, DateTime.now().day))
  ];

  final _todos_key = 'todos';

  SharedPreferences? prefs;

  void initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  TodoModel() {
    SharedPreferences.getInstance().then(
      (SharedPreferences sp) {
        prefs = sp;
        _todos = sp.getStringList(_todos_key) == null ? [] : sp.getStringList(_todos_key)!.map(
          (e) {
            return Todo.fromMap(json.decode(e));
          }).toList();
      notifyListeners();
      }
    );
  }

  UnmodifiableListView<Todo> get todos => UnmodifiableListView(_todos);

  void saveTodos() async {
    List<String> encodedTodos =
        todos.map((e) => json.encode(e.toMap())).toList();
    await prefs!.setStringList(_todos_key, encodedTodos);
  }

  void loadTodos() async {
    if (prefs != null && prefs!.containsKey(_todos_key)) {
      List<String> l = prefs!.getStringList(_todos_key)!;
      _todos = l.map((e) => Todo.fromMap(json.decode(e))).toList();
    }
  }

  int nextId () {
    return todos.length == 0 ? 0 : _todos.last.id! + 1;
  }

  void add(Todo todo) {
    _todos.add(todo);
    saveTodos();
    notifyListeners();
  }

  void update(int id, String newTitle, String newDescription) {
    var todo = _todos.firstWhere((todo) => todo.id == id);
    todo.title = newTitle;
    todo.description = newDescription;
    saveTodos();
    notifyListeners();
  }

  void delete(int id) {
    _todos.removeWhere((todo) => todo.id == id);
    saveTodos();
    notifyListeners();
  }

  Todo read(int? id) {
    return _todos.firstWhere((element) => element.id == id);
  }

  // int _compareTodos(Todo a, Todo b) {
  //   if (a.isDone == b.isDone) {
  //     return 0;
  //   } else if (a.isDone) {
  //     return 1;
  //   }
  //   return -1;
  // }

  void toggleDone(int? id) {
    var index = _todos.indexWhere((element) => element.id == id);
    _todos[index].isDone = !_todos[index].isDone!;
    for (int i = 0; i < _todos.length; i++) {
      _todos[i].id = i;
    }
    saveTodos();
    notifyListeners();
    // _todos.sort(_compareTodos);
  }

  void remove(int id) {
    _todos.removeWhere((element) => element.id == id);
    saveTodos();
    notifyListeners();
  }
}
