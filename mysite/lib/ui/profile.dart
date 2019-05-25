import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import '../database/user.dart';
import '../utility/current.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage> {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.txt');
  }

  Future<File> writeContent(String data) async {
    final file = await _localFile;
    await file.writeAsString('${data}');
  }

  UserBase user = UserBase();
  final _formkey = GlobalKey<FormState>();
  final userid = TextEditingController(text: CurrentUser.userId);
  final name = TextEditingController(text: CurrentUser.name);
  final age = TextEditingController(text: CurrentUser.age);
  final password = TextEditingController();
  final quote = TextEditingController(text: CurrentUser.quote);

  bool isUserIn = false;

  bool isNum(String i) {
    if (i == null) {
      return false;
    }
    return double.parse(i) != null;
  }

  int countingSpace(String x) {
    int count = 0;
    for (int i = 0; i < x.length; i++) {
      if (x[i] == ' ') {
        count += 1;
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile Setting"),
        ),
        body: Form(
          key: _formkey,
          child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 15, 30, 0),
              children: <Widget>[
                TextFormField(
                    decoration: InputDecoration(
                      labelText: "User Id",
                      hintText: "User Id must be between 6 to 12",
                      icon:
                          Icon(Icons.account_box, size: 40, color: Colors.grey),
                    ),
                    controller: userid,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please fill out this form";
                      } else if (isUserIn) {
                        return "This Username is taken";
                      } else if (value.length < 6 || value.length > 12) {
                        return "Please fill UserId wrong";
                      }
                    }),
                TextFormField(
                    decoration: InputDecoration(
                      labelText: "Name",
                      hintText: "ex. 'Elon Musk'",
                      icon: Icon(Icons.account_circle,
                          size: 40, color: Colors.grey),
                    ),
                    controller: name,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please fill out this form";
                      } else if (countingSpace(value) != 1) {
                        return "You fill Name wrong";
                      }
                    }),
                TextFormField(
                    decoration: InputDecoration(
                      labelText: "Age",
                      hintText: "Please fill Age Between 10 to 80",
                      icon:
                          Icon(Icons.event_note, size: 40, color: Colors.grey),
                    ),
                    controller: age,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please fill Age";
                      } else if (!isNum(value) ||
                          int.parse(value) < 10 ||
                          int.parse(value) > 80) {
                        return "You fill Age wrong";
                      }
                    }),
                TextFormField(
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Password must be longer than 6",
                      icon: Icon(Icons.lock, size: 40, color: Colors.grey),
                    ),
                    controller: password,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty || value.length <= 6) {
                        return "You fill password wrong";
                      }
                    }),
                TextFormField(
                    decoration: InputDecoration(
                      labelText: "Quote",
                      hintText: "Tell something about your self",
                      icon: Icon(Icons.settings_system_daydream,
                          size: 40, color: Colors.grey),
                    ),
                    controller: quote,
                    keyboardType: TextInputType.text,
                    maxLines: 3),
                RaisedButton(
                    child: Text("SAVE"),
                    onPressed: () async {
                      await user.open("user.db");
                      Future<List<User>> allUser = user.getAllUser();
                      User userData = User();
                      userData.id = CurrentUser.id;
                      userData.userid = userid.text;
                      userData.name = name.text;
                      userData.age = age.text;
                      userData.password = password.text;
                      userData.quote = quote.text;
                      writeContent(userData.quote);
                      Future isUserTaken(User user) async {
                        var userList = await allUser;
                        for (var i = 0; i < userList.length; i++) {
                          if (user.userid == userList[i].userid &&
                              CurrentUser.id != userList[i].id) {
                            this.isUserIn = true;
                            break;
                          }
                        }
                      }

                      if (_formkey.currentState.validate()) {
                        await isUserTaken(userData);
                        if (!this.isUserIn) {
                          await user.updateUser(userData);
                          CurrentUser.userId = userData.userid;
                          CurrentUser.name = userData.name;
                          CurrentUser.age = userData.age;
                          CurrentUser.password = userData.password;
                          CurrentUser.quote = userData.quote;
                          Navigator.pop(context);
                        }
                      }
                      this.isUserIn = false;
                    }),
              ]),
        ));
  }
}
