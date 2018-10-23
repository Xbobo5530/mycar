import 'package:flutter/material.dart';
import 'package:my_car/functions/functions.dart';
import 'package:my_car/functions/login_fun.dart';
import 'package:my_car/models/answer.dart';
import 'package:my_car/models/main_scopped_model.dart';
import 'package:my_car/models/user.dart';
import 'package:my_car/pages/user_profile.dart';
import 'package:my_car/views/upvote_button.dart';
import 'package:scoped_model/scoped_model.dart';

final userFun = User();
final ansFun = Answer();
final fun = Functions();
final loginFun = LoginFunctions();

class AnswerItemView extends StatelessWidget {
  final Answer answer;

  AnswerItemView({this.answer});

  @override
  Widget build(BuildContext context) {
    _openUserProfile(User user) {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return UserProfilePage(user: user);
          });
    }

    var _userSection = ScopedModelDescendant<MyCarModel>(
      builder: (BuildContext context, Widget child, MyCarModel model) {
        model.getUserFromId(answer.userId);

        return GestureDetector(
          onTap: model.userFromId != null
              ? () => _openUserProfile(model.userFromId)
              : null,
          child: Chip(
              avatar: model.userFromId != null
                  ? CircleAvatar(
                backgroundImage: NetworkImage(model.userFromId.imageUrl),
                backgroundColor: Colors.black12,
              )
                  : Icon(Icons.account_circle),
              label: model.userFromId != null
                  ? Text(model.userFromId.name)
                  : LinearProgressIndicator()),
        );
      },
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(
            answer.answer,
          ),
        ),
        subtitle: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _userSection,
              UpvoteButtonView(answer: answer) //_upvoteSection,
            ],
          ),
        ),
      ),
    );
  }
}
