import 'package:flutter/material.dart';
import 'package:my_car/models/main_model.dart';
import 'package:my_car/models/question.dart';
import 'package:my_car/pages/login.dart';
import 'package:my_car/utils/status_code.dart';
import 'package:my_car/utils/strings.dart';
import 'package:my_car/views/labeled_flat_button.dart';
import 'package:my_car/views/my_progress_indicator.dart';
import 'package:scoped_model/scoped_model.dart';

class FollowButtonView extends StatelessWidget {
  final Question question;

  FollowButtonView({this.question});

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

    _followQuestion(BuildContext context, MainModel model) async {
      if (!model.isLoggedIn) _goToLoginPage();
      StatusCode statusCode =
      await model.handleFollowQuestion(question, model.currentUser.id);
      if (statusCode == StatusCode.failed)
        Scaffold.of(context).showSnackBar(snackBar);
    }

    return ScopedModelDescendant<MainModel>(builder: (_, __, model) {
      return FutureBuilder<bool>(
          initialData: false,
          future: model.isUserFollowing(question, model.currentUser.id),
          builder: (context, snapshot) {
            final isFollowing = snapshot.data;
            return Builder(
              builder: (context) {
                return LabeledFlatButton(
                    icon:
                    model.handlingFollowQuestionStatus == StatusCode.waiting
                        ? MyProgressIndicator(
                      size: 15.0,
                      color: isFollowing ? Colors.blue : Colors.grey,
                    )
                        : Icon(Icons.rss_feed,
                        size: 18.0,
                        color: isFollowing ? Colors.blue : Colors.grey),
                    label: Text(isFollowing ? followingText : followText,
                        style: TextStyle(
                            color: isFollowing ? Colors.blue : Colors.grey)),
                    onTap: () => _followQuestion(context, model));
              },
            );
          });
    });
  }
}
