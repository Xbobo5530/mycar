import 'package:flutter/material.dart';
import 'package:my_car/models/question.dart';
import 'package:my_car/models/user.dart';
import 'package:my_car/pages/answe_question.dart';
import 'package:my_car/pages/view_question.dart';
import 'package:my_car/values/strings.dart';

final userFun = User();

class QuestionItemView extends StatefulWidget {
  final Question question;
  final String source;

  QuestionItemView({this.question, this.source});

  @override
  _QuestionItemViewState createState() => _QuestionItemViewState();
}

class _QuestionItemViewState extends State<QuestionItemView> {
  User user;
  @override
  Widget build(BuildContext context) {
    void getUserDetails() async {
      User _user = await userFun.getUserFromUserId(widget.question.userId);
      setState(() {
        user = _user;
      });
    }

    getUserDetails();

    void _likeQuestion() {}

    _answerQuestion() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => AnswerQuestionPage(question: widget.question),
              fullscreenDialog: true));
    }

    void _shareQuestion() {}

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

    return Column(
      children: <Widget>[
        ListTile(
          onTap: widget.source == 'HomePage' ? () => _openQuestion() : null,
          title: Text(
            widget.question.question,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
        ),
        Row(
          children: <Widget>[
            user != null
                ? Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(user.imageUrl),
                radius: 12.0,
              ),
            )
                : Icon(Icons.account_circle, size: 45.0),
            user != null
                ? Text(user.name)
                : Container(
              width: 4.0,
              color: Colors.black12,
            ),
          ],
        ),
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildButton(Icons.share, shareText, _shareQuestion),
            _buildButton(Icons.thumb_up, upVoteText, _likeQuestion),
            _buildButton(Icons.edit, answerText, _answerQuestion),
          ],
        )
      ],
    );
  }
}
