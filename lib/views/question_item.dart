import 'package:flutter/material.dart';
import 'package:my_car/functions/functions.dart';
import 'package:my_car/functions/login_fun.dart';
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
import 'package:scoped_model/scoped_model.dart';
import 'package:share/share.dart';

const tag = 'QuestionItemView';

final userFun = User();
final qnFun = Question();
final fun = Functions();
final loginFun = LoginFunctions();

class QuestionItemView extends StatefulWidget {
  final Question question;
  final String source;

  /// method to call when the question is tapped
  /// null when when the question should now respond to a tap
  final GestureTapCallback onTap;

  QuestionItemView({Key key, @required this.question, this.source, this.onTap})
      : super(key: key);

  @override
  _QuestionItemViewState createState() => _QuestionItemViewState();
}

class _QuestionItemViewState extends State<QuestionItemView> {
  User _user;
  bool _isDisposed = false;

  @override
  void initState() {
    (() async {
      var questionUserId = widget.question.userId;
      User questionUser = await userFun.getUserFromUserId(questionUserId);
      if (!_isDisposed)
        setState(() {
          _user = questionUser;
        });
    })();
    super.initState();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool enabled = widget.onTap != null;

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
              builder: (_) => AnswerQuestionPage(question: widget.question),
              fullscreenDialog: true));
    }

    _shareQuestion() {
      Share.share('${widget.question.question}\nshared from the MyCar App');
    }

    _openUserProfile(User user) {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return UserProfilePage(user: user);
          });
    }

    var _userSection = GestureDetector(
      onTap: _user != null ? () => _openUserProfile(_user) : null,
      child: Chip(
        label: _user != null ? Text(_user.name) : Text(loadingText),
        avatar: _user != null
            ? CircleAvatar(
          backgroundColor: Colors.black12,
          backgroundImage: NetworkImage(_user.imageUrl),
        )
            : Icon(Icons.account_circle),
      ),
    );

    var _midSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _userSection,
          AnswersCountView(question: widget.question)
        ],
      ),
    );

    var _shareButton = LabeledFlatButton(
        icon: Icon(Icons.share, size: 18.0, color: Colors.grey),
        label: Text(shareText),
        onTap: () => _shareQuestion());

    var _answerButton = ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return LabeledFlatButton(
            icon: Icon(Icons.edit, size: 18.0, color: Colors.grey),
            label: Text(answerText),
            onTap: model.isLoggedIn
                ? () => _goToAnswerQuestionPage()
                : () => _goToLoginPage());
      },
    );

    var _actionsSection = Material(
      elevation: 4.0,
      child: ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          _shareButton,
          FollowButtonView(
            question: widget.question,
          ),
          _answerButton,
        ],
      ),
    );

    var _questionDetailsSection = ListTile(
      onTap: enabled ? widget.onTap : null,
      title: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          widget.question.question,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
      ),
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
