import 'package:flutter/material.dart';
import 'package:my_car/functions/functions.dart';
import 'package:my_car/functions/login_fun.dart';
import 'package:my_car/pages/ask.dart';
import 'package:my_car/pages/login.dart';
import 'package:my_car/pages/my_profile.dart';
import 'package:my_car/values/strings.dart';
import 'package:my_car/views/posts_content.dart';
import 'package:my_car/views/welcome_card.dart';

const tag = 'HomePage:';
final functions = Functions();
final loginFunctions = LoginFunctions();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    loginFunctions.isLoggedIn().then((isLoggedIn) {
      setState(() {
        _isLoggedIn = isLoggedIn;
      });
    });

    _goToProfilePage() {
      _isLoggedIn
          ? Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => UserProfilePage(), fullscreenDialog: true))
          : Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => LoginPage(), fullscreenDialog: true));
    }

    _goToLoginPage() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => LoginPage(), fullscreenDialog: true));
    }

    _createNewThread() {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => AskPage(), fullscreenDialog: true));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(APP_NAME),
          leading: FlatButton(
              child: Icon(Icons.add),
              onPressed: _isLoggedIn
                  ? () => _createNewThread()
                  : () => _goToLoginPage()),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () => _goToProfilePage(),
                icon: Icon(
                  Icons.account_circle,
                  size: 30.0,
                ),
              ),
            )
          ],
        ),
        body: ListView(
          children: <Widget>[
            WelcomeCardView(),
            PostsPageView(),
          ],
        ));
  }
}
