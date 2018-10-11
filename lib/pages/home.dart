import 'package:flutter/material.dart';
import 'package:my_car/functions/functions.dart';
import 'package:my_car/pages/login.dart';
import 'package:my_car/values/strings.dart';
import 'package:my_car/views/posts_content.dart';
import 'package:my_car/views/welcome_card.dart';

const tag = 'HomePage:';
final functions = Functions();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _isLoggedIn = false;
  var _inputSection = Container();

  @override
  Widget build(BuildContext context) {
    functions.getCurrentUser().then((user) {
      setState(() {
        user != null ? _isLoggedIn = true : _isLoggedIn = false;
      });
    });

    return new Scaffold(
      appBar: AppBar(
        title: Text(APP_NAME),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.account_circle,
              size: 30.0,
            ),
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          WelcomeCardView(),
          PostsPageView(),
          _inputSection,
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.edit),
          onPressed: _isLoggedIn
              ? () => _createNewThread(context)
              : () => _goToLoginPage(context)),
    );
  }

  _goToLoginPage(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage(), fullscreenDialog: true));
  }

  _createNewThread(BuildContext context) {
    setState(() {
      _inputSection = Container(
        child: Row(
          children: <Widget>[
            Expanded(
                child: TextField(
              decoration: InputDecoration(labelText: replyLabelText),
            ))
          ],
        ),
      );
    });
  }
}
