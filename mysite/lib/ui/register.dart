import 'package:flutter/material.dart';
import '../database/user.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPage> {
  UserBase user = UserBase();
  final _formkey = GlobalKey<FormState>();
  final userid = TextEditingController();
  final name = TextEditingController();
  final age = TextEditingController();
  final password = TextEditingController();
  final password2nd = TextEditingController();
  final quote = TextEditingController();
  bool userIn = false;
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s) != null;
  }

  int countSpace(String s) {
    int result = 0;
    for (int i = 0; i < s.length; i++) {
      if (s[i] == ' ') {
        result += 1;
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Register"),
      ),
      body: Form(
        key: _formkey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 30, 30),
          children: <Widget>[
            TextFormField(
                decoration: InputDecoration(
                  labelText: "User ID",
                  hintText: "User ID have to be between 6 to 12",
                  icon: Icon(
                    Icons.account_box,
                    size: 20,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                controller: userid,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please fill out this form";
                  } else if (value.length < 6 || value.length > 12) {
                    return "Please fill UserId Correctly";
                  } else if (this.userIn) {
                    return "This Username is taken";
                  }
                }),
            TextFormField(
                decoration: InputDecoration(
                  labelText: "Name",
                  hintText: "ex. 'Kavepol Khunsri'",
                  icon: Icon(
                    Icons.account_circle,
                    size: 20,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                controller: name,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please fill out this form";
                  }
                  if (countSpace(value) != 1) {
                    return "Please fill Name Correctly";
                  }
                }),
            TextFormField(
                decoration: InputDecoration(
                  labelText: "Age",
                  hintText: "Please fill Age Between 10 to 80",
                  icon: Icon(
                    Icons.event_note,
                    size: 20,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                controller: age,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please fill Age";
                  } else if (!isNumeric(value) ||
                      int.parse(value) < 10 ||
                      int.parse(value) > 80) {
                    return "Please fill Age correctly";
                  }
                }),
            TextFormField(
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "Password must be longer than 6",
                  icon: Icon(
                    Icons.lock,
                    size: 20,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                controller: password,
                obscureText: true,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isEmpty || value.length <= 6) {
                    return "Please fill Password Correctly";
                  }
                }),
            TextFormField(
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  hintText: "Password must be the same",
                  icon: Icon(
                    Icons.lock,
                    size: 20,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                controller: password2nd,
                obscureText: true,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isEmpty || value != password.text) {
                    return "Please fill Password as last line";
                  }
                }),
            RaisedButton(
                child: Text("Register new account"),
                onPressed: () async {
                  await user.open("user.db");
                  Future<List<User>> allUser = user.getAllUser();
                  User userData = User();
                  userData.userid = userid.text;
                  userData.name = name.text;
                  userData.age = age.text;
                  userData.password = password.text;
                  Future isNewUserIn(User user) async {
                    var userList = await allUser;
                    for (var i = 0; i < userList.length; i++) {
                      if (user.userid == userList[i].userid) {
                        this.userIn = true;
                        break;
                      }
                    }
                  }
                  await isNewUserIn(userData);
                  if (_formkey.currentState.validate()) {
                    if (!this.userIn) {
                      userid.text = "";
                      name.text = "";
                      age.text = "";
                      password.text = "";
                      password2nd.text = "";
                      await user.insertUser(userData);
                      Navigator.pop(context);
                    }
                  }
                  this.userIn = false;
                }),
          ],
        ),
      ),
    );
  }
}