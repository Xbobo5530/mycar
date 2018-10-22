import 'package:flutter/material.dart';
import 'package:my_car/functions/functions.dart';
import 'package:my_car/functions/login_fun.dart';
import 'package:my_car/functions/status_code.dart';
import 'package:my_car/models/question.dart';
import 'package:my_car/models/user.dart';
import 'package:my_car/pages/answer_question.dart';
import 'package:my_car/pages/login.dart';
import 'package:my_car/pages/user_profile.dart';
import 'package:my_car/pages/view_question.dart';
import 'package:my_car/values/strings.dart';
import 'package:my_car/views/labeled_flat_button.dart';

final userFun = User();
final qnFun = Question();
final fun = Functions();
final loginFun = LoginFunctions();

class QuestionItemView extends StatefulWidget {
  final Question question;
  final String source;

  QuestionItemView({this.question, this.source});

  @override
  _QuestionItemViewState createState() => _QuestionItemViewState();
}

class _QuestionItemViewState extends State<QuestionItemView> {
  User _user;
  bool _hasFollowed = false;
  bool _isLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    loginFun.isLoggedIn().then((isLoggedIn) {
      setState(() {
        _isLoggedIn = isLoggedIn;
      });
    });

    userFun.getUserFromUserId(widget.question.userId).then((user) {
      setState(() {
        _user = user;
      });
    });

    _isLoggedIn
        ? fun.userHasFollowed(widget.question).then((hasFollowed) {
      setState(() {
        _hasFollowed = hasFollowed;
      });
    })
        : _hasFollowed = false;

    _answerQuestion() async {
      bool _isLoggedIn = await loginFun.isLoggedIn();
      _isLoggedIn
          ? Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => AnswerQuestionPage(question: widget.question),
              fullscreenDialog: true))
          : Navigator.push(
          context, MaterialPageRoute(builder: (_) => LoginPage()));
    }

    _shareQuestion() {
      //todo handle share question
    }

    final snackBar = SnackBar(
      content: Text(errorMessage),
    );

    _followQuestion() async {
      if (_isLoggedIn) {
        StatusCode statusCode = await fun.followQuestion(widget.question);
        if (statusCode == StatusCode.failed)
          Scaffold.of(context).showSnackBar(snackBar);
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
      }
    }

    _openQuestion() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ViewQuestionPage(question: widget.question),
              fullscreenDialog: true));
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
              : Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
            child: Icon(Icons.account_circle, size: 24.0),
          ),
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
          subtitle: _userSection,
        ),
        ButtonBar(
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            LabeledFlatButton(
                icon: Icon(Icons.share, size: 18.0, color: Colors.grey),
                label: Text(shareText),
                onTap: () => _shareQuestion()),
            LabeledFlatButton(
                icon: Icon(Icons.rss_feed,
                    size: 18.0,
                    color: _hasFollowed ? Colors.blue : Colors.grey),
                label: Text(followText,
                    style: TextStyle(
                        color: _hasFollowed ? Colors.blue : Colors.grey)),
                onTap: () => _followQuestion()),
            LabeledFlatButton(
                icon: Icon(Icons.edit, size: 18.0, color: Colors.grey),
                label: Text(answerText),
                onTap: () => _answerQuestion()),
          ],
        )
      ],
    );
  }
}
