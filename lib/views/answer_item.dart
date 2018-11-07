import 'package:flutter/material.dart';
import 'package:my_car/models/answer.dart';
import 'package:my_car/models/main_model.dart';
import 'package:my_car/models/user.dart';
import 'package:my_car/pages/user_profile.dart';
import 'package:my_car/utils/strings.dart';
import 'package:my_car/views/upvote_button.dart';
import 'package:scoped_model/scoped_model.dart';

class AnswerItemView extends StatelessWidget {
  final Answer answer;

  AnswerItemView({Key key, this.answer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final createdBy =
        answer.createdBy != null ? answer.createdBy : answer.userId;

    _openUserProfile(User user) {
      showModalBottomSheet(
          context: context,
          builder: (_) {
            return UserProfilePage(user: user);
          });
    }

    final _userSection =
        ScopedModelDescendant<MainModel>(builder: (_, __, model) {
      return FutureBuilder<User>(
        future: model.getUserFromUserId(createdBy),
        builder: (_, snapshot) {
          if (!snapshot.hasData)
            return Chip(
              label: Text(loadingText),
            );
          final answerUser = snapshot.data;
          return GestureDetector(
            onTap:
                answerUser != null ? () => _openUserProfile(answerUser) : null,
            child: Chip(
                avatar: answerUser.imageUrl != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(answerUser.imageUrl),
                        backgroundColor: Colors.black12,
                      )
                    : Icon(Icons.account_circle),
                label: answerUser != null
                    ? Text(answerUser.name)
                    : Text(loadingText)),
          );
        },
      );
    });

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
      child: Column(
        children: <Widget>[
          ListTile(
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
                  UpvoteButtonView(answer: answer),
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
