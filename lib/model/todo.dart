import 'dart:convert';

class Todo {
  int? id;
  String? title;
  String? description;
  DateTime? dueDate;
  List<Subtask>? subTasks;
  bool? isDone = false;

  Todo({this.id, this.title, this.description, this.dueDate, this.subTasks});

  Todo.fromMap(Map m)
      : this.id = m['id'],
        this.title = m['title'],
        this.description = m['description'],
        this.dueDate = DateTime.tryParse(m['dueDate']),
        this.subTasks = m['subtasks'] == null
            ? <Subtask>[]
            : json.decode(m['subtasks']).map((e) => e.fromMap()),
        this.isDone = m['isDone'];

  Map toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toString(),
      'subtasks': subTasks!.map((e) => json.encode(e.toMap())).toList(),
      'isDone': isDone,
    };
  }
}

class Subtask {
  String description;
  bool isDone = false;

  Subtask(this.description, this.isDone);

  Subtask.fromMap(Map m)
      : this.description = m['description'],
        this.isDone = m['isDone'];

  Map toMap() {
    return {
      'description': description,
      'bool': isDone,
    };
  }
}
