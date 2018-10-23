import 'package:flutter/material.dart';
import 'package:my_car/functions/functions.dart';
import 'package:my_car/functions/login_fun.dart';
import 'package:my_car/functions/status_code.dart';
import 'package:my_car/models/login_scopped_model.dart';
import 'package:my_car/models/question.dart';
import 'package:my_car/models/user.dart';
import 'package:my_car/pages/answer_question.dart';
import 'package:my_car/pages/login.dart';
import 'package:my_car/pages/user_profile.dart';
import 'package:my_car/pages/view_question.dart';
import 'package:my_car/values/strings.dart';
import 'package:my_car/views/labeled_flat_button.dart';
import 'package:scoped_model/scoped_model.dart';

final userFun = User();
final qnFun = Question();
final fun = Functions();
final loginFun = LoginFunctions();

class QuestionItemView extends StatelessWidget {
  final Question question;
  final String source;

  QuestionItemView({this.question, this.source});
  @override
  Widget build(BuildContext context) {
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
      //todo handle share question
    }

    final snackBar = SnackBar(
      content: Text(errorMessage),
    );

    _followQuestion() async {
      StatusCode statusCode = await fun.followQuestion(question);
      if (statusCode == StatusCode.failed)
        Scaffold.of(context).showSnackBar(snackBar);
    }

    _openQuestion() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ViewQuestionPage(question: question),
              fullscreenDialog: true));
    }

    _openUserProfile(User user) {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return UserProfilePage(user: user);
          });
    }

    var _userSection = Container(
      child: Row(
        children: <Widget>[
          ScopedModelDescendant<MyCarModel>(
            builder: (BuildContext context, Widget child, MyCarModel model) {
              model.getUserFromId(question.userId);
              var _user = model.userFromId;
              return GestureDetector(
                onTap: _user != null ? () => _openUserProfile(_user) : null,
                child: Chip(
                  label: _user != null
                      ? Text(_user.name)
                      : LinearProgressIndicator(),
                  avatar: _user != null
                      ? CircleAvatar(
                    backgroundColor: Colors.black12,
                    backgroundImage: NetworkImage(_user.imageUrl),
                  )
                      : Icon(Icons.account_circle),
                ),
              );
            },
          )
        ],
      ),
    );

    var _followButton = ScopedModelDescendant<MyCarModel>(
      builder: (BuildContext context, Widget child, MyCarModel model) {
        model.hasUserFollowed(question);

        return LabeledFlatButton(
            icon: Icon(Icons.rss_feed,
                size: 18.0,
                color: model.hasFollowed ? Colors.blue : Colors.grey),
            label: Text(followText,
                style: TextStyle(
                    color: model.hasFollowed ? Colors.blue : Colors.grey)),
            onTap: model.hasFollowed
                ? () => _followQuestion()
                : () => _goToLoginPage());
      },
    );

    var _shareButton = LabeledFlatButton(
        icon: Icon(Icons.share, size: 18.0, color: Colors.grey),
        label: Text(shareText),
        onTap: () => _shareQuestion());

    var _answerButton = ScopedModelDescendant<MyCarModel>(
      builder: (BuildContext context, Widget child, MyCarModel model) {
        return LabeledFlatButton(
            icon: Icon(Icons.edit, size: 18.0, color: Colors.grey),
            label: Text(answerText),
            onTap: model.isLoggedIn
                ? () => _goToAnswerQuestionPage()
                : () => _goToLoginPage());
      },
    );

    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
      child: Column(
        children: <Widget>[
          ListTile(
            onTap: source == 'HomePage' ? () => _openQuestion() : null,
            title: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                question.question,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
            ),
            subtitle: _userSection,
          ),
          Material(
            elevation: 4.0,
            child: ButtonBar(
              alignment: MainAxisAlignment.center,
              children: <Widget>[
                _shareButton,
                _followButton,
                _answerButton,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
