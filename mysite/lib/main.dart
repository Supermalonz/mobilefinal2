import 'package:flutter/material.dart';
import './ui/login.dart';
import './ui/register.dart';
import './ui/home.dart';
import './ui/profile.dart';
import './ui/friend.dart';

void main() => runApp(MyApp());
const PrimaryColor = const Color(0xff0758DE);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Final 2019',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: PrimaryColor,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => LoginPage(),
        "/register": (context) => RegisterPage(),
        "/home": (context) => HomePage(),
        "/profile": (context) => ProfilePage(),
        "/friend": (context) => FriendPage(),
      },
    );
  }
}