import 'package:flutter/material.dart';
import 'package:my_car/functions/login_fun.dart';
import 'package:my_car/models/user.dart';
import 'package:my_car/values/strings.dart';

final loginFunctions = LoginFunctions();
final usersFun = User();

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    _logout() {
      loginFunctions.logout();
      Navigator.pop(context);
    }

    var basicInfoSection = ListTile();

    return Scaffold(
      appBar: AppBar(
        title: Text(myProfileText),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () => _logout(),
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          basicInfoSection,
        ],
      ),
    );
  }
}
