import 'package:flutter/material.dart';
import 'dart:async';
// import 'package:shared_preferences/shared_preferences.dart';

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

// TO DO it is better to be able to class sharing between _MyHomePageState and _MySimpleDialogState
String input = '';

class _MyHomePageState extends State<MyHomePage> {
  final todoTexts = <String>[];
  // final _prefs = SharedPreferences.getInstance();

  void _init() {
    // TO DO read data from shared preferences.
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  Widget _makeTodoItem(String text) {
    return Padding(
        padding: new EdgeInsets.all(10.0),
        child: new Text(
          text,
          style: TextStyle(fontSize: 24.0),
        )
      );
  }

  void _addTodo(String todo) {
    setState(() {
      todoTexts.insert(0, todo);
    });
  }

  Future<Null> _askedToAdd() async {
    switch (await showDialog<Answer>(
      context: context,
      builder: (BuildContext context) {
        return new MySimpleDialog();
      }
    )) {
      case Answer.ADD:
        _addTodo(input);
        break;

      case Answer.CANCEL:
        break;
    }
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
              itemCount: todoTexts.length,
              itemBuilder: (BuildContext context, int index) {
                final todo = todoTexts[index];
                return Dismissible(
                    key: Key('todo_$index'),
                    onDismissed: (direction) => todoTexts.removeAt(index),
                    child: _makeTodoItem(todo),
                    background: Container(color: Colors.red),
                );
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

class MySimpleDialog extends StatefulWidget {
  MySimpleDialog({Key key}) : super(key: key);

  @override
  _MySimpleDialogState createState() => new _MySimpleDialogState();
}

class _MySimpleDialogState extends State<MySimpleDialog> {
  final controller = TextEditingController();
  String errorMsg = '';

  void _setErrorMessage(text) {
    setState(() {
      errorMsg = text;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Add a new todo'),
      children: <Widget>[
        Padding(
          padding: new EdgeInsets.only(left: 8.0, right: 8.0),
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
                  errorMsg = (controller.text == '')? 'input a new todo.': '';
                  _setErrorMessage(errorMsg);
                  if (errorMsg != '') {
                    return;
                  }
                  input = controller.text;
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
                  _setErrorMessage('');
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
}