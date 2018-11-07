import 'package:flutter/material.dart';
import 'package:my_car/models/main_model.dart';
import 'package:my_car/utils/status_code.dart';
import 'package:my_car/utils/strings.dart';
import 'package:my_car/views/my_progress_indicator.dart';
import 'package:scoped_model/scoped_model.dart';

const _tag = 'LoginPage:';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final snackBar = SnackBar(
      content: Text(errorMessage),
    );

    _signInWithGoogle(BuildContext context, MainModel model) async {
      StatusCode loginStatusCode = await model.singInWithGoogle();

      switch (loginStatusCode) {
        case StatusCode.failed:
          Scaffold.of(context).showSnackBar(snackBar);
          break;
        case StatusCode.success:
          Navigator.pop(context);
          break;
        default:
          print('$_tag login status code is $loginStatusCode');
      }
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
            return ScopedModelDescendant<MainModel>(
              builder: (BuildContext context, Widget child, model) {
                return FlatButton(
                    textColor: Colors.blue,
                    child: model.loginStatus == StatusCode.waiting
                        ? MyProgressIndicator(
                            size: 15.0,
                            color: Colors.cyan,
                          )
                        : Text(signInWithGoogleText),
                    onPressed: model.loginStatus == StatusCode.waiting
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
