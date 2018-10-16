import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Todo',
      home: new MyHomePage(title: 'Todo List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

enum Answer {
  ADD,
  CANCEL
}

class _MyHomePageState extends State<MyHomePage> {
  final todoList = <Widget>[];
  final controller = TextEditingController();
  String errorMsg = '';

  Widget _makeTodoItem(String text) {
    return Padding(
        padding: new EdgeInsets.all(10.0),
        child: new Text(
          text,
          style: TextStyle(fontSize: 24.0),
        )
      );
  }

  SimpleDialog _addTodoDialog() {
    return SimpleDialog(
      title: const Text('Add a new todo'),
      // TODO styling
      children: <Widget>[
        Padding(
          padding: new EdgeInsets.all(4.0),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'new todo'
            ),
          ),
        ),
        Padding(
          padding: new EdgeInsets.only(left: 8.0, right: 8.0),
          child: Text(
            errorMsg,
            style: TextStyle(color: Colors.red),
          )
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: SimpleDialogOption(
                onPressed: () {
                  // TODO fix to the timing that errorMsg shows when add button pressed.
                  setState(() {
                    errorMsg = (controller.text == '')? 'input a new todo.': '';
                  });
                  if (errorMsg != '') {
                    return;
                  }
                  Navigator.pop(context, Answer.ADD);
                },
                child: const Text(
                  'Add',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: SimpleDialogOption(
                onPressed: () {
                  setState(() {
                    errorMsg = '';
                  });
                  Navigator.pop(context, Answer.CANCEL);
                },
                child: const Text(
                  'Cancel',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  void _addTodo(String todo) {
    setState(() {
      todoList.insert(0, _makeTodoItem(todo));
    });
  }

  Future<Null> _askedToAdd() async {
    switch (await showDialog<Answer>(
      context: context,
      builder: (BuildContext context) {
        return _addTodoDialog();
      }
    )) {
      case Answer.ADD:
        _addTodo(controller.text);
        controller.clear();
        break;

      case Answer.CANCEL:
        break;
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Column(
        children: <Widget>[
          new Expanded(
            child: new ListView.builder(
              itemCount: todoList.length,
              itemBuilder: (BuildContext context, int index) {
                return todoList[index];
              },
            ),
          ),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _askedToAdd,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}
