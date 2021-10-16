class Todo {
  int id;
  String title;
  String description;
  DateTime dueDate;
  bool isDone = false;

  Todo({this.id, this.title, this.description, this.dueDate});

  Todo.fromMap(Map m) :
    this.id = m['id'],
  this.title = m['title'],
  this.description = m['description'],
  this.dueDate = DateTime.parse(m['dueDate']),
  this.isDone = m['isDone'];

  Map toMap() {
    return {
  'id': id,
  'title': title,
  'description': description,
  'dueDate': dueDate.toString(),
  'isDone': isDone,
    };
  }
}