import 'package:flutter/material.dart';
import 'package:my_car/src/models/scope_models/main_model.dart';
import 'package:my_car/src/models/question.dart';
import 'package:my_car/src/pages/answer_question.dart';
import 'package:my_car/src/pages/login.dart';
import 'package:my_car/src/utils/strings.dart';
import 'package:my_car/src/views/follow_button.dart';
import 'package:my_car/src/views/labeled_flat_button.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:share/share.dart';

class QuestionActionsView extends StatelessWidget {
  final Question question;

  QuestionActionsView({this.question});

  @override
  Widget build(BuildContext context) {
    _shareQuestion() {
      Share.share('${question.question}\nshared from the MyCar App');
    }

    _goToAnswerQuestionPage() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => AnswerQuestionPage(question: question),
              fullscreenDialog: true));
    }

    final _shareButton = LabeledFlatButton(
        icon: Icon(Icons.share, size: 18.0, color: Colors.grey),
        label: Text(shareText),
        onTap: () => _shareQuestion());

    _goToLoginPage() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return LoginPage();
          });
    }

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
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        _shareButton,
        FollowButtonView(question: question, key: Key(question.id)),
        _answerButton,
      ],
    );
  }
}
