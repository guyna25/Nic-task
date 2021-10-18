//packages
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nic_task/model/todo.dart';
import 'package:nic_task/screens/app_drawer.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';

//relative import
import 'todo_detail_screen.dart';
import '../state/todo_model.dart';

//utilities
import 'dart:math';

class TodoScreen extends StatefulWidget {
  static const routeName = "/";

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  ConfettiController? ctrlCenter;

  _TodoScreenState() {
    ctrlCenter = ConfettiController(duration: const Duration(seconds: 1));
  }

  Align buildConfettiWidget(controller, double blastDirection) {
    return Align(
      alignment: Alignment.center,
      child: ConfettiWidget(
        maximumSize: Size(30, 30),
        shouldLoop: false,
        confettiController: controller,
        blastDirection: blastDirection,
        blastDirectionality: BlastDirectionality.explosive,
        maxBlastForce: 20, // set a lower max blast force
        minBlastForce: 8, // set a lower min blast force
        emissionFrequency: 1,
        numberOfParticles: 4, // a lot of particles at once
        gravity: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo list"),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            buildConfettiWidget(ctrlCenter, pi / 1),
            TodoList(ctrlCenter),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // final m = Provider.of<TodoModel>(context, listen: false).todos;
          Navigator.pushNamed(context, TodoDetailScreen.routeName);
        },
      ),
      drawer: AppDrawer(),
    );
  }
}

class TodoList extends StatelessWidget {
  final ConfettiController? ctrl;

  TodoList(this.ctrl);

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoModel>(
        builder: (context, todoModel, child) => ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: todoModel.todos.length,
            itemBuilder: (BuildContext context, int index) {
              Todo tempTodo = todoModel.todos[index];
              String? formattedDate = null;
              if (tempTodo.dueDate != null) {
                var formatter = new DateFormat('dd-MM-yy');
                formattedDate = formatter.format(tempTodo.dueDate!);
              }
              return Container(
                height: 50,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Transform.scale(
                        scale: 2.0,
                        child: Checkbox(
                          value: tempTodo.isDone,
                          onChanged: (bool? newValue) {
                            if (newValue!) {
                              ctrl!.play();
                            }
                            todoModel.toggleDone(tempTodo.id);
                          },
                        ),
                      ),
                      Text(tempTodo.title!),
                      formattedDate != null ? Text(formattedDate) : new Container(),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => {
                          Navigator.pushNamed(
                              context, TodoDetailScreen.routeName,
                              arguments: ScreenArguments(tempTodo.id,))
                        },
                      )
                    ]),
              );
            }));
  }
}
