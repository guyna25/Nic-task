import 'package:flutter/material.dart';
import 'package:nic_task/screens/todo_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello Friend!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Tasks'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(TodoScreen.routeName);
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
