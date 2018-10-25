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
  StatusCode _upvoteStatus;

  @override
  void initState() {
    (() async {
      bool hasUpvoted = await fun.userHasUpvoted(widget.answer);
      setState(() {
        _hasUpvoted = hasUpvoted;
        print('$tag _hasUpcoted is $hasUpvoted');
      });
    })();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final snackBar = SnackBar(
      content: Text(errorMessage),
    );

    _goToLoginPage() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return LoginPage();
          });
    }

    _upVoteAnswer() async {
      bool isLoggedIn = await loginFun.isLoggedIn();
      setState(() {
        isLoggedIn = isLoggedIn;
      });

      if (isLoggedIn) {
        setState(() {
          _upvoteStatus = StatusCode.waiting;
        });

        StatusCode statusCode = await fun.upvoteAnswer(widget.answer);
        bool hasUpvoted = await fun.userHasUpvoted(widget.answer);

        if (statusCode == StatusCode.failed) {
          Scaffold.of(context).showSnackBar(snackBar);
        } else {
          setState(() {
            _hasUpvoted = hasUpvoted;
          });
        }

        setState(() {
          _upvoteStatus = statusCode;
        });
      } else
        _goToLoginPage();
    }

    return _upvoteStatus == StatusCode.waiting
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
      onTap: () => _upVoteAnswer(),
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
