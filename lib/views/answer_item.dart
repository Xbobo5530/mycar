import 'package:flutter/material.dart';
import 'package:my_car/functions/functions.dart';
import 'package:my_car/functions/status_code.dart';
import 'package:my_car/models/answer.dart';
import 'package:my_car/models/user.dart';
import 'package:my_car/pages/my_profile.dart';
import 'package:my_car/values/strings.dart';

final userFun = User();
final ansFun = Answer();
final fun = Functions();

class AnswerItemView extends StatefulWidget {
  final Answer answer;

  AnswerItemView({this.answer});

  @override
  _AnswerItemViewState createState() => _AnswerItemViewState();
}

class _AnswerItemViewState extends State<AnswerItemView> {
  User _user;
  bool _hasUpvoted = false;

  @override
  Widget build(BuildContext context) {
    userFun.getUserFromUserId(widget.answer.userId).then((user) {
      //todo check error on closing the answer page
      setState(() {
        _user = user;
      });
    });

    fun.userHasUpvoted(widget.answer).then((hasUpvoted) {
      setState(() {
        _hasUpvoted = hasUpvoted;
      });
    });

    _openUserProfile() {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => UserProfilePage(user: _user)));
    }

    var _userSection = _user != null
        ? InkWell(
            onTap: () => _openUserProfile(),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CircleAvatar(
                    radius: 12.0,
                    backgroundImage: NetworkImage(
                      _user.imageUrl,
                    ),
                  ),
                ),
                Text(_user.name)
              ],
            ),
          )
        : Container();

    final snackBar = SnackBar(
      content: Text(errorMessage),
    );

    _upVoteAnswer() async {
      //todo handle up vote answer
      StatusCode statusCode = await fun.upvoteAnswer(widget.answer);
      if (statusCode == StatusCode.failed)
        Scaffold.of(context).showSnackBar(snackBar);
    }

    var _voteSection = InkWell(
      onTap: () => _upVoteAnswer(),
      child: Row(children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Icon(
            Icons.thumb_up,
            size: 18.0,
            color: _hasUpvoted ? Colors.blue : Colors.grey,
          ),
        ),
        Text(
          upvoteText,
          style: TextStyle(color: _hasUpvoted ? Colors.blue : Colors.grey),
        ),
      ]),
    );

    return ListTile(
      title: Text(
        widget.answer.answer,
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[_userSection, _voteSection],
      ),
    );
  }
}
