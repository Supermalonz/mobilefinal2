import 'package:flutter/material.dart';
import '../utility/current.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Home"),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Hello ${CurrentUser.name}'),
              subtitle: Text('this is my quote "${CurrentUser.quote}"'),
            ),
            RaisedButton(
              child: Text("PROFILE SETTING"),
              onPressed: () {
                Navigator.of(context).pushNamed('/profile');
              },
            ),
            RaisedButton(
              child: Text("MY FRIENDS"),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/friend');
              },
            ),
            RaisedButton(
              child: Text("SIGN OUT"),
              onPressed: () {
                CurrentUser.userId = null;
                CurrentUser.name = null;
                CurrentUser.age = null;
                CurrentUser.password = null;
                CurrentUser.quote = null;
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
