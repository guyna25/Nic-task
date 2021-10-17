import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/todo.dart';
import '../state/todo_model.dart';

class ScreenArguments {
  final int? todoId;

  ScreenArguments(this.todoId);
}

class TodoDetailScreen extends StatelessWidget {
  static const routeName = '/entry';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Create todo"),
        ),
        body: SingleChildScrollView(child: TodoForm()));
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
  final subtaskController = TextEditingController();
  DateTime? dueDate;
  bool isEditForm = false;
  late Todo editableTodo;
  List<Subtask> subtasks = <Subtask>[];

  final TodoModel? todoModel;

  TodoFormState({this.todoModel});

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    subtaskController.dispose();
    super.dispose();
  }

  void createTodo(Function addTodo) {
    var todo = new Todo(
      id: Provider.of<TodoModel>(context, listen: false).nextId(),
      title: titleController.text,
      description: descriptionController.text,
      dueDate: dueDate,
      subTasks: subtasks,
    );
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
    final ScreenArguments? arguments = ModalRoute.of(context)!.settings.arguments as ScreenArguments?;
    if (arguments != null && arguments.todoId != null) {
      isEditForm = true;
      final m = Provider.of<TodoModel>(context, listen: false);
      editableTodo = m.read(arguments.todoId);
      titleController.text = editableTodo.title!;
      descriptionController.text = editableTodo.description!;
      subtaskController.text = '';
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
                    child: Column(
                      children: <Widget>[
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: subtasks.length,
                            itemBuilder: (BuildContext ctx, int idx) {
                              Subtask subtask = subtasks[idx];
                              return CheckboxListTile(
                                title: Text(subtask.description),
                                secondary: Icon(Icons.beach_access),
                                value: subtask.isDone,
                                onChanged: (bool? value) {
                                  setState(() {
                                    subtask.isDone = value!= null ? value : false;
                                  });
                                }
                              );
                            }),
                        TextField(
                          controller: subtaskController,
                          decoration: InputDecoration(
                            prefixIcon: IconButton(
                              onPressed: () {
                                subtasks.add(Subtask(subtaskController.text, false));
                                subtaskController.clear();
                                setState(() {});
                              },
                              icon: Icon(Icons.add),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.task_alt),
                        labelText: 'Notes',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      // label: Text('date'),
                      icon: Icon(Icons.date_range),
                      onPressed: () async {
                        dueDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2026, 1, 1));
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
