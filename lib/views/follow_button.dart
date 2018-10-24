import 'package:flutter/material.dart';
import 'package:my_car/functions/functions.dart';
import 'package:my_car/functions/login_fun.dart';
import 'package:my_car/functions/status_code.dart';
import 'package:my_car/models/question.dart';
import 'package:my_car/pages/login.dart';
import 'package:my_car/values/strings.dart';
import 'package:my_car/views/labeled_flat_button.dart';
import 'package:my_car/views/my_progress_indicator.dart';

const tag = 'FollowButtonView:';
final fun = Functions();
final loginFun = LoginFunctions();

class FollowButtonView extends StatefulWidget {
  final Question question;

  FollowButtonView({this.question});

  @override
  _FollowButtonViewState createState() => _FollowButtonViewState();
}

class _FollowButtonViewState extends State<FollowButtonView> {
  bool _isFollowing = false;
  bool _isLoggedIn = false;
  StatusCode _followStatus;

  @override
  void initState() {
    (() async {
      bool isFollowing = await fun.isUserFollowing(widget.question);
      bool isLoggedIn = await loginFun.isLoggedIn();
      setState(() {
        _isFollowing = isFollowing;
        _isLoggedIn = isLoggedIn;
      });
    })();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //todo fix when user logs in, the isLoggedIn var doesn't change

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

    _followQuestion() async {
      setState(() {
        _followStatus = StatusCode.waiting;
      });

      StatusCode statusCode = await fun.followQuestion(widget.question);
      bool isFollowing = await fun.isUserFollowing(widget.question);
      if (statusCode == StatusCode.failed) {
        Scaffold.of(context).showSnackBar(snackBar);
      } else {
        setState(() {
          _isFollowing = isFollowing;
        });
      }

      setState(() {
        _followStatus = statusCode;
      });
    }

    return LabeledFlatButton(
        icon: _followStatus == StatusCode.waiting
            ? MyProgressIndicator(
          size: 15.0,
          color: _isFollowing ? Colors.blue : Colors.grey,
        )
            : Icon(Icons.rss_feed,
            size: 18.0, color: _isFollowing ? Colors.blue : Colors.grey),
        label: Text(_isFollowing ? followingText : followText,
            style: TextStyle(color: _isFollowing ? Colors.blue : Colors.grey)),
        onTap: _isLoggedIn ? () => _followQuestion() : () => _goToLoginPage());
  }
}
