import 'package:flutter/material.dart';
import 'package:my_car/functions/status_code.dart';
import 'package:my_car/models/question.dart';
import 'package:my_car/models/user.dart';
import 'package:my_car/pages/answe_question.dart';
import 'package:my_car/pages/my_profile.dart';
import 'package:my_car/pages/view_question.dart';
import 'package:my_car/values/strings.dart';

final userFun = User();
final qnFun = Question();

class QuestionItemView extends StatefulWidget {
  final Question question;
  final String source;

  QuestionItemView({this.question, this.source});

  @override
  _QuestionItemViewState createState() => _QuestionItemViewState();
}

class _QuestionItemViewState extends State<QuestionItemView> {
  User _user;
  @override
  Widget build(BuildContext context) {
    userFun.getUserFromUserId(widget.question.userId).then((user) {
      setState(() {
        _user = user;
      });
    });
    _answerQuestion() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => AnswerQuestionPage(question: widget.question),
              fullscreenDialog: true));
    }

    _shareQuestion() {
      //todo handle share question
    }
    _followQuestion() async {
      //todo handle follow question
      StatusCode statusCode = await qnFun.followQuestion(widget.question);
    }

    _openQuestion() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ViewQuestionPage(question: widget.question),
              fullscreenDialog: true));
    }

    Widget _buildButton(IconData icon, String label, void onTap()) {
      return InkWell(
          onTap: () => onTap(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  icon,
                  size: 18.0,
                  color: Colors.grey,
                ),
              ),
              Text(label)
            ],
          ));
    }

    _openUserProfile() {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => UserProfilePage(user: _user)));
    }

    var _userSection = InkWell(
      onTap: () => _openUserProfile(),
      child: Row(
        children: <Widget>[
          _user != null
              ? Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(_user.imageUrl),
              radius: 12.0,
            ),
          )
              : Icon(Icons.account_circle, size: 45.0),
          _user != null
              ? Text(_user.name)
              : Container(
            width: 4.0,
            color: Colors.black12,
          ),
        ],
      ),
    );

    return Column(
      children: <Widget>[
        ListTile(
          onTap: widget.source == 'HomePage' ? () => _openQuestion() : null,
          title: Text(
            widget.question.question,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
        ),
        _userSection,
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildButton(Icons.share, shareText, _shareQuestion),
            _buildButton(Icons.rss_feed, followText, _followQuestion),
            _buildButton(Icons.edit, answerText, _answerQuestion),
          ],
        )
      ],
    );
  }
}
