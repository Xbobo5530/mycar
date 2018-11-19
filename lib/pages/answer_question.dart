import 'package:flutter/material.dart';
import 'package:my_car/models/answer.dart';
import 'package:my_car/models/main_model.dart';
import 'package:my_car/models/question.dart';
import 'package:my_car/models/user.dart';
import 'package:my_car/utils/colors.dart';
import 'package:my_car/utils/status_code.dart';
import 'package:my_car/utils/strings.dart';
import 'package:my_car/views/heading_section.dart';
import 'package:my_car/views/my_progress_indicator.dart';
import 'package:scoped_model/scoped_model.dart';

const _tag = 'AnswerQuestionPage:';

class AnswerQuestionPage extends StatelessWidget {
  final Question question;

  AnswerQuestionPage({@required this.question});

  @override
  Widget build(BuildContext mainContext) {
    final createdBy =
        question.createdBy != null ? question.createdBy : question.userId;

    final _answerController = TextEditingController();

    final snackBar = SnackBar(
      content: Text(errorMessage),
    );

    _submitAnswer(BuildContext context, MainModel model) async {
      final answerText = _answerController.text.trim();

      if (answerText.isNotEmpty) {
        Answer answer = Answer(
            answer: answerText,
            questionId: question.id,
            votes: 0,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            createdBy: model.currentUser.id);

        StatusCode statusCode = await model.submitAnswer(answer);
        switch (statusCode) {
          //todo test if can pop main context
          case StatusCode.success:
            Navigator.pop(mainContext);
            break;
          case StatusCode.failed:
            Scaffold.of(context).showSnackBar(snackBar);
            break;
          default:
            print('$_tag status code is $statusCode');
        }
      }
    }

    final _questionSection = Material(
      elevation: 4.0,
      child: ScopedModelDescendant<MainModel>(builder: (_, __, model) {
        return FutureBuilder<User>(
          future: model.getUserFromUserId(createdBy),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            User questionUser = snapshot.data;
            return HeadingSectionView(
              imageUrl: questionUser.imageUrl,
              heading: question.question,
            );
          },
        );
      }),
    );

    final _answerField = Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: TextField(
            controller: _answerController,
            maxLines: 20,
            decoration:
                InputDecoration(border: InputBorder.none, hintText: answerHint),
          ),
        ),
      ),
    );

    final _actions = ButtonBar(
      children: <Widget>[
        ScopedModelDescendant<MainModel>(
          builder: (_, __, model) {
            return Builder(
              builder: (context) {
                return RaisedButton(
                  color: darkColor,
                  onPressed: () =>
                      model.submittingAnswerStatus == StatusCode.waiting
                          ? null
                          : _submitAnswer(context, model),
                  child: model.submittingAnswerStatus == StatusCode.waiting
                      ? MyProgressIndicator(
                          size: 15.0,
                          color: Colors.white,
                        )
                      : Text(
                          submitText,
                          style: TextStyle(color: Colors.white),
                        ),
                );
              },
            );
          },
        )
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(answerText),
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          _questionSection,
          _answerField,
          _actions,
        ],
      ),
    );
  }
}
