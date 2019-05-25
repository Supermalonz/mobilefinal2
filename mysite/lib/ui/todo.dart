import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

Future<List<Todo>> fetchTodos(int userid) async {
  final response = await http
      .get('https://jsonplaceholder.typicode.com/todos?userId=$userid');

  List<Todo> api = [];

  if (response.statusCode == 200) {
    var body = json.decode(response.body);
    for (int i = 0; i < body.length; i++) {
      var todo = Todo.fromJson(body[i]);
      print(todo);
      if (todo.userid == userid) {
        api.add(todo);
        
        //for testing if it works or not
      }
    }
    return api;
  } else {
    throw Exception('Failed to load post !!!');
  }
}

class Todo {
  final int userid;
  final int id;
  final String title;
  final String completed;

  Todo({this.userid, this.id, this.title, this.completed});

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      userid: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: (json['completed'] ? "Completed" : ""),
    );
  }
}

class TodoPage extends StatelessWidget {
  TodoPage({Key key, @required this.id}) : super(key: key);
  final int id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todos"),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("BACK"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FutureBuilder(
              future: fetchTodos(this.id),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return new Text('loading...');
                  default:
                    if (snapshot.hasError) {
                      return new Text('Error: ${snapshot.error}');
                    } else {
                      return createListView(context, snapshot);
                    }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Todo> shotuser = snapshot.data;
    return new Expanded(
      child: new ListView.builder(
        itemCount: shotuser.length,
        itemBuilder: (BuildContext context, int index) {
          return new Card(
            child: InkWell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    (shotuser[index].id).toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 10)),
                  Text(
                    shotuser[index].title,
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    shotuser[index].completed,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
