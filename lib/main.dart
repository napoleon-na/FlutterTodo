import 'package:flutter/material.dart';

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

class _MyHomePageState extends State<MyHomePage> {
  final todoList = <Widget>[];

  Widget _makeTodoItem(String text) {
    return Padding(
        padding: new EdgeInsets.all(10.0),
        child: new Text(
          text,
          style: TextStyle(fontSize: 24.0),
        )
      );
  }

  void _incrementCounter() {
    // TODO: show modal to add new todo item
    setState(() {
      todoList.add(_makeTodoItem('add text'));
    });
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
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}
