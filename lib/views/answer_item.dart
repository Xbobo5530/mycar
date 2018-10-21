import 'package:flutter/material.dart';
import 'package:my_car/models/answer.dart';
import 'package:my_car/models/user.dart';
import 'package:my_car/pages/my_profile.dart';

final userFun = User();

class AnswerItemView extends StatefulWidget {
  final Answer answer;

  AnswerItemView({this.answer});

  @override
  _AnswerItemViewState createState() => _AnswerItemViewState();
}

class _AnswerItemViewState extends State<AnswerItemView> {
  User user;

  @override
  Widget build(BuildContext context) {
    userFun.getUserFromUserId(widget.answer.userId).then((_user) {
      setState(() {
        user = _user;
      });
    });

    _openUserProfile() {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => UserProfilePage(user: user)));
    }

    var _userSection = InkWell(
      onTap: () => _openUserProfile(),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              radius: 12.0,
              backgroundImage: NetworkImage(
                user.imageUrl,
              ),
            ),
          ),
          Text(user.name)
        ],
      ),
    );

    return ListTile(
      title: Text(widget.answer.answer),
      subtitle: user != null ? _userSection : Container(),
    );
  }
}
