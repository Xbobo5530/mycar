import 'package:flutter/material.dart';
import 'package:my_car/functions/functions.dart';
import 'package:my_car/functions/login_fun.dart';
import 'package:my_car/functions/status_code.dart';
import 'package:my_car/models/answer.dart';
import 'package:my_car/pages/login.dart';
import 'package:my_car/values/strings.dart';

const tag = 'UpvoteButtonView:';
final fun = Functions();
final loginFun = LoginFunctions();

class UpvoteButtonView extends StatefulWidget {
  final Answer answer;

  UpvoteButtonView({this.answer});

  @override
  _UpvoteButtonViewState createState() => _UpvoteButtonViewState();
}

class _UpvoteButtonViewState extends State<UpvoteButtonView> {
  bool _hasUpvoted = false;
  bool _isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    (() async {
      bool hasUpvoted = await fun.userHasUpvoted(widget.answer);
      bool isLoggedIn = await loginFun.isLoggedIn();
      setState(() {
        _hasUpvoted = hasUpvoted;
        _isLoggedIn = isLoggedIn;
      });
    })();

    final snackBar = SnackBar(
      content: Text(errorMessage),
    );

    _upVoteAnswer() async {
      StatusCode statusCode = await fun.upvoteAnswer(widget.answer);
      if (statusCode == StatusCode.failed)
        Scaffold.of(context).showSnackBar(snackBar);
    }

    _goToLoginPage() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return LoginPage();
          });
    }

    return GestureDetector(
      onTap: _isLoggedIn ? () => _upVoteAnswer() : () => _goToLoginPage(),
      child: Chip(
          avatar: Icon(
            Icons.thumb_up,
            size: 20.0,
            color: _hasUpvoted ? Colors.blue : Colors.grey,
          ),
          label: Text(
            _hasUpvoted ? upvotedText : upvoteText,
            style: TextStyle(color: _hasUpvoted ? Colors.blue : Colors.grey),
          )),
    );
  }
}
