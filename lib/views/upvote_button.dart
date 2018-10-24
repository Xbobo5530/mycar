import 'package:flutter/material.dart';
import 'package:my_car/functions/functions.dart';
import 'package:my_car/functions/login_fun.dart';
import 'package:my_car/functions/status_code.dart';
import 'package:my_car/models/answer.dart';
import 'package:my_car/pages/login.dart';
import 'package:my_car/values/strings.dart';
import 'package:my_car/views/my_progress_indicator.dart';

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
  StatusCode _isUpvoting;

  @override
  void initState() {
    (() async {
      bool hasUpvoted = await fun.userHasUpvoted(widget.answer);
      bool isLoggedIn = await loginFun.isLoggedIn();
      setState(() {
        _hasUpvoted = hasUpvoted;
        _isLoggedIn = isLoggedIn;
      });
    })();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final snackBar = SnackBar(
      content: Text(errorMessage),
    );

    _upVoteAnswer() async {
      setState(() {
        _isUpvoting = StatusCode.waiting;
      });

      bool hasUpvoted = await fun.userHasUpvoted(widget.answer);
      StatusCode statusCode = await fun.upvoteAnswer(widget.answer);

      if (statusCode == StatusCode.failed) {
        Scaffold.of(context).showSnackBar(snackBar);
      } else {
        setState(() {
          _hasUpvoted = hasUpvoted;
        });
      }

      setState(() {
        _isUpvoting = statusCode;
      });
    }

    _goToLoginPage() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return LoginPage();
          });
    }

    return _isUpvoting == StatusCode.waiting
        ? Chip(
      avatar: MyProgressIndicator(
        size: 15.0,
        color: _hasUpvoted ? Colors.blue : Colors.grey,
      ),
      label: Text(
        _hasUpvoted ? upvotedText : upvoteText,
        style: TextStyle(color: _hasUpvoted ? Colors.blue : Colors.grey),
      ),
    )
        : GestureDetector(
      onTap: _isLoggedIn ? () => _upVoteAnswer() : () => _goToLoginPage(),
      child: Chip(
          avatar: _hasUpvoted
              ? Icon(
            Icons.done,
            size: 20.0,
            color: Colors.blue,
          )
              : Icon(Icons.thumb_up, color: Colors.grey),
          label: Text(
            _hasUpvoted ? upvotedText : upvoteText,
            style:
            TextStyle(color: _hasUpvoted ? Colors.blue : Colors.grey),
          )),
    );
  }
}
