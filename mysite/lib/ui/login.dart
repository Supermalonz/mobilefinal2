import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import '../database/user.dart';
import '../utility/current.dart';
import '../ui/register.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  final userid = TextEditingController();
  final password = TextEditingController();
  UserBase user = UserBase();
  bool isValid = false;
  int howMany = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Form(
        key: _formkey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
          children: <Widget>[
            Image.network(
              "https://www.easykeys.com/Images/Keys_Cut/chicago/chicago_1250-1499_cut_key_large.png",
              width: 200,
              height: 200,
            ),
            TextFormField(
                decoration: InputDecoration(
                  labelText: "User",
                  icon: Icon(
                    Icons.account_box,
                    size: 30,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                controller: userid,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isNotEmpty) {
                    this.howMany += 1;
                  }
                }),
            TextFormField(
                decoration: InputDecoration(
                  labelText: "Password",
                  icon: Icon(
                    Icons.lock,
                    size: 30,
                    color: Theme.of(context).primaryColorDark,
                  ),
                ),
                controller: password,
                obscureText: true,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isNotEmpty) {
                    this.howMany += 1;
                  }
                }),
            Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 10)),
            RaisedButton(
              child: Text("Login"),
              onPressed: () async {
                _formkey.currentState.validate();
                await user.open("user.db");
                Future<List<User>> allUser = user.getAllUser();

                Future isUserValid(String userid, String password) async {
                  var userList = await allUser;
                  for (var i = 0; i < userList.length; i++) {
                    if (userid == userList[i].userid &&
                        password == userList[i].password) {
                      CurrentUser.id = userList[i].id;
                      CurrentUser.userId = userList[i].userid;
                      CurrentUser.name = userList[i].name;
                      CurrentUser.age = userList[i].age;
                      CurrentUser.password = userList[i].password;
                      CurrentUser.quote = userList[i].quote;
                      this.isValid = true;
                      print("Passed !!!");
                      break;
                    }
                  }
                }

                if (this.howMany != 2) {
                  Toast.show("Please fill out this form", context,
                      duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                  this.howMany = 0;
                } else {
                  this.howMany = 0;
                  print("${userid.text}, ${password.text}");
                  //too see user password
                  await isUserValid(userid.text, password.text);
                  if (!this.isValid) {
                    Toast.show("Invalid user or password", context,
                        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                  } else {
                    Navigator.pushReplacementNamed(context, '/home');
                    userid.text = "";
                    password.text = "";
                  }
                }
              },
            ),
            FlatButton(
              child: Container(
                child: Text("Register new user"),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/register');
              },
              padding: EdgeInsets.only(left: 130),
            ),
          ],
        ),
      ),
    );
  }
}
