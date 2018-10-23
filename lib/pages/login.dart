import 'package:flutter/material.dart';
import 'package:my_car/functions/functions.dart';
import 'package:my_car/functions/login_fun.dart';
import 'package:my_car/functions/status_code.dart';
import 'package:my_car/models/main_scopped_model.dart';
import 'package:my_car/values/strings.dart';
import 'package:my_car/views/my_progress_indicator.dart';
import 'package:scoped_model/scoped_model.dart';

const tag = 'LoginPage:';
final functions = Functions();
final loginFunctions = LoginFunctions();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  StatusCode _loginStatus;

  @override
  Widget build(BuildContext context) {
    final snackBar = SnackBar(
      content: Text(errorMessage),
    );

    _signInWithGoogle(BuildContext context, MyCarModel model) async {
      setState(() {
        _loginStatus = StatusCode.waiting;
      });
      StatusCode loginStatusCode = await loginFunctions.singInWithGoogle();
      model.getLoginStatus();
      model.getCurrentUser();

      setState(() {
        _loginStatus = loginStatusCode;
      });
      loginStatusCode == StatusCode.success
          ? Navigator.pop(context)
          : Scaffold.of(context).showSnackBar(snackBar);
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: Container(),
        title: Text(loginText),
      ),
      body: Center(
        child: Builder(
          builder: (context) {
            return ScopedModelDescendant<MyCarModel>(
              builder: (BuildContext context, Widget child, model) {
                return FlatButton(
                    textColor: Colors.blue,
                    child: _loginStatus == StatusCode.waiting
                        ? MyProgressIndicator(
                            size: 15.0,
                            color: Colors.cyan,
                          )
                        : Text(signInWithGoogleText),
                    onPressed: _loginStatus == StatusCode.waiting
                        ? null
                        : () => _signInWithGoogle(context, model));
              },
            );
          },
        ),
      ),
    );
  }
}
