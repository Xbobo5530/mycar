import 'package:flutter/material.dart';
import 'package:my_car/functions/functions.dart';
import 'package:my_car/models/question.dart';
import 'package:my_car/values/strings.dart';

final fun = Functions();

class AnswerQuestionPage extends StatelessWidget {
  final Question question;

  AnswerQuestionPage({this.question});

  @override
  Widget build(BuildContext context) {
    var _answerController = TextEditingController();

    final snackBar = SnackBar(
      content: Text(errorMessage),
    );

    _submitAnswer(BuildContext context) async {
      var answer = _answerController.text.trim();

      if (answer.isNotEmpty) {
        StatusCode statusCode = await fun.submitAnswer(question, answer);
        statusCode == StatusCode.success
            ? Navigator.pop(context)
            : Scaffold.of(context).showSnackBar(snackBar);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(answerText),
      ),
      body: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              question.question,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: TextField(
                  controller: _answerController,
                  maxLines: 20,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: answerHint),
                ),
              ),
            ),
          ),
          ButtonBar(
            children: <Widget>[
              RaisedButton(
                color: Colors.cyan,
                onPressed: () => _submitAnswer(context),
                child: Text(submitText),
              )
            ],
          )
        ],
      ),
    );
  }
}
