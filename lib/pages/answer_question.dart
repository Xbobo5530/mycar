import 'package:flutter/material.dart';
import 'package:my_car/functions/functions.dart';
import 'package:my_car/functions/status_code.dart';
import 'package:my_car/models/question.dart';
import 'package:my_car/values/strings.dart';
import 'package:my_car/views/my_progress_indicator.dart';

final fun = Functions();

class AnswerQuestionPage extends StatefulWidget {
  final Question question;

  AnswerQuestionPage({this.question});

  @override
  _AnswerQuestionPageState createState() => _AnswerQuestionPageState();
}

class _AnswerQuestionPageState extends State<AnswerQuestionPage> {
  StatusCode _submitStatus;

  @override
  Widget build(BuildContext context) {
    var _answerController = TextEditingController();

    final snackBar = SnackBar(
      content: Text(errorMessage),
    );

    _submitAnswer(BuildContext context) async {
      var answer = _answerController.text.trim();

      if (answer.isNotEmpty) {
        setState(() {
          _submitStatus = StatusCode.waiting;
        });

        StatusCode statusCode = await fun.submitAnswer(widget.question, answer);
        setState(() {
          _submitStatus = statusCode;
        });

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
              widget.question.question,
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
                onPressed: () => _submitStatus == StatusCode.waiting
                    ? null
                    : _submitAnswer(context),
                child: _submitStatus == StatusCode.waiting
                    ? MyProgressIndicator(
                        size: 15.0,
                        color: Colors.white,
                      )
                    : Text(submitText),
              )
            ],
          )
        ],
      ),
    );
  }
}
