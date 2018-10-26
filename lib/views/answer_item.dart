import 'package:flutter/material.dart';
import 'package:my_car/functions/functions.dart';
import 'package:my_car/functions/login_fun.dart';
import 'package:my_car/models/answer.dart';
import 'package:my_car/models/user.dart';
import 'package:my_car/pages/user_profile.dart';
import 'package:my_car/values/strings.dart';
import 'package:my_car/views/upvote_button.dart';

final userFun = User();
final ansFun = Answer();
final fun = Functions();
final loginFun = LoginFunctions();

class AnswerItemView extends StatefulWidget {
  final Answer answer;

  AnswerItemView({Key key, this.answer}) : super(key: key);

  @override
  _AnswerItemViewState createState() => _AnswerItemViewState();
}

class _AnswerItemViewState extends State<AnswerItemView> {
  User _user;
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;

    super.dispose();
  }

  @override
  void initState() {
    (() async {
      var answerUserId = widget.answer.userId;
      User answerUser = await userFun.getUserFromUserId(answerUserId);
      if (!_isDisposed)
        setState(() {
          _user = answerUser;
        });
    })();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _openUserProfile(User user) {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return UserProfilePage(user: user);
          });
    }

    var _userSection = GestureDetector(
      onTap: _user != null ? () => _openUserProfile(_user) : null,
      child: Chip(
          avatar: _user != null && _user.imageUrl != null
              ? CircleAvatar(
            backgroundImage: NetworkImage(_user.imageUrl),
            backgroundColor: Colors.black12,
          )
              : Icon(Icons.account_circle),
          label: _user != null ? Text(_user.name) : Text(loadingText)),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                widget.answer.answer,
              ),
            ),
            subtitle: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _userSection,
                  UpvoteButtonView(answer: widget.answer),
                ],
              ),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
