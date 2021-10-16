import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/todo.dart';
import '../state/todo_model.dart';

class ScreenArguments {
  final int todoId;

  ScreenArguments(this.todoId);
}

class TodoEntryScreen extends StatelessWidget {
  static const routeName = '/entry';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Create todo"),
        ),
        body: TodoForm());
  }
}

class TodoForm extends StatefulWidget {
  @override
  TodoFormState createState() {
    return TodoFormState();
  }
}

class TodoFormState extends State<TodoForm> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  DateTime dueDate;
  bool isEditForm = false;
  Todo editableTodo;

  final TodoModel todoModel;

  TodoFormState({this.todoModel});

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void createTodo(Function addTodo) {
    var todo = new Todo(
        title: titleController.text, description: descriptionController.text, dueDate: dueDate);
    addTodo(todo);
    Navigator.pop(context);
  }

  void editTodo(Function editTodo) {
    editTodo(editableTodo.id, titleController.text, descriptionController.text);
    Navigator.pop(context);
  }

  void deleteTodo(Function deleteTodo) {
    deleteTodo(editableTodo.id);
    Navigator.pop(context);
  }

  void loadTodoForEdit(BuildContext context) {
    final ScreenArguments arguments = ModalRoute.of(context).settings.arguments;
    if (arguments != null && arguments.todoId != null) {
      isEditForm = true;
      final m = Provider.of<TodoModel>(context, listen: false);
      editableTodo = m.read(arguments.todoId);
      titleController.text = editableTodo.title;
      descriptionController.text = editableTodo.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    loadTodoForEdit(context);
    return Form(
        key: _formKey,
        child: Consumer<TodoModel>(
            builder: (context, todoModel, child) => Column(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.task_alt),
                        labelText: 'Task name',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.task_alt),
                        hintText: 'Precise descriptions are better',
                        labelText: 'Task Description',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      // label: Text('date'),
                      icon: Icon(Icons.date_range),
                      onPressed: () async {
                        dueDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2026, 1, 1));
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        child: Text(isEditForm ? "Update" : "Save"),
                        onPressed: () => {
                          isEditForm
                              ? editTodo(todoModel.update)
                              : createTodo(todoModel.add)
                        },
                      ),
                      isEditForm
                          ? Padding(padding: EdgeInsets.all(3))
                          : new Container(),
                      isEditForm
                          ? ElevatedButton(
                              child: Text("Delete"),
                              onPressed: () {
                                deleteTodo(todoModel.delete);
                              },
                            )
                          : new Container()
                    ],
                  ),
                ])));
  }
}
