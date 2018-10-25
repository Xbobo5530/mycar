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
  StatusCode _followStatus;
  bool _isDisposed = false;

  @override
  void initState() {
    (() async {
      bool isFollowing = await fun.isUserFollowing(widget.question);
      if (!_isDisposed)
        setState(() {
          _isFollowing = isFollowing;
        });
    })();
    super.initState();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
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

    _followQuestion() async {
      bool isLoggedIn = await loginFun.isLoggedIn();

      if (isLoggedIn) {
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
      } else
        _goToLoginPage();
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
        onTap: () => _followQuestion());
  }
}
