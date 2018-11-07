import 'package:flutter/material.dart';
import 'package:my_car/models/main_model.dart';
import 'package:my_car/models/question.dart';
import 'package:my_car/models/user.dart';
import 'package:my_car/pages/answer_question.dart';
import 'package:my_car/pages/login.dart';
import 'package:my_car/pages/user_profile.dart';
import 'package:my_car/utils/strings.dart';
import 'package:my_car/views/answers_count.dart';
import 'package:my_car/views/follow_button.dart';
import 'package:my_car/views/labeled_flat_button.dart';
import 'package:my_car/views/my_progress_indicator.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:share/share.dart';

class QuestionItemView extends StatelessWidget {
  final Question question;
  final String source;
  final GestureTapCallback onTap;

  QuestionItemView({Key key, @required this.question, this.source, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool enabled = onTap != null;
    String createdBy =
    question.createdBy == null ? question.userId : question.createdBy;
    _goToLoginPage() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return LoginPage();
          });
    }

    _goToAnswerQuestionPage() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => AnswerQuestionPage(question: question),
              fullscreenDialog: true));
    }

    _shareQuestion() {
      Share.share('${question.question}\nshared from the MyCar App');
    }

    //todo add dynamic links to questions

    _openUserProfile(User user) {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return UserProfilePage(user: user);
          });
    }

    final _userSection =
    ScopedModelDescendant<MainModel>(builder: (_, __, model) {
      return FutureBuilder<User>(
        future: model.getUserFromUserId(createdBy),
        builder: (_, snapshot) {
          if (!snapshot.hasData)
            return MyProgressIndicator(
              color: Colors.black12,
              size: 15.0,
            );
          final questionUser = snapshot.data;
          return GestureDetector(
            onTap: questionUser != null
                ? () => _openUserProfile(questionUser)
                : null,
            child: Chip(
              label: Text(questionUser.name),
              avatar: questionUser.imageUrl != null
                  ? CircleAvatar(
                backgroundColor: Colors.black12,
                backgroundImage: NetworkImage(questionUser.imageUrl),
              )
                  : Icon(Icons.account_circle, color: Colors.grey),
            ),
          );
        },
      );
    });

    final _midSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[_userSection, AnswersCountView(question: question)],
      ),
    );

    final _shareButton = LabeledFlatButton(
        icon: Icon(Icons.share, size: 18.0, color: Colors.grey),
        label: Text(shareText),
        onTap: () => _shareQuestion());

    final _answerButton = ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return LabeledFlatButton(
            icon: Icon(Icons.edit, size: 18.0, color: Colors.grey),
            label: Text(answerText),
            onTap: model.isLoggedIn
                ? () => _goToAnswerQuestionPage()
                : () => _goToLoginPage());
      },
    );

    final _actionsSection = Material(
      elevation: 4.0,
      child: ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          _shareButton,
          FollowButtonView(
            question: question,
          ),
          _answerButton,
        ],
      ),
    );

    final _topSection = Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        question.question,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
      ),
    );

    final _questionDetailsSection = ListTile(
      onTap: enabled ? onTap : null,
      title: _topSection,
      subtitle: _midSection,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
      child: Column(
        children: <Widget>[
          _questionDetailsSection,
          _actionsSection,
        ],
      ),
    );
  }
}
