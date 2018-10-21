import 'package:flutter/material.dart';
import 'package:my_car/functions/functions.dart';
import 'package:my_car/functions/login_fun.dart';
import 'package:my_car/pages/home.dart';
import 'package:my_car/values/strings.dart';

const tag = 'LoginPage:';
final functions = Functions();
final loginFunctions = LoginFunctions();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var progressSection;

  @override
  Widget build(BuildContext context) {
    _goToHomePage() {
      print('$tag at _goToHomePage');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }

    _signInWithGoogle() async {
      bool signInCompleted = await loginFunctions.singInWithGoogle();
      signInCompleted ? _goToHomePage() : CircularProgressIndicator();
    }

//    _showProgress() {}

    return Scaffold(
      appBar: AppBar(
        title: Text(loginText),
      ),
      body: Center(
        child: RaisedButton(
            child: Text(signInWithGoogleText),
            onPressed: () {
//              CircularProgressIndicator();
              _signInWithGoogle();
            }),
      ),
    );
  }
}
