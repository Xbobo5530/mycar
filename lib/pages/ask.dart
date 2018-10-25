import 'package:flutter/material.dart';
import 'package:my_car/functions/functions.dart';
import 'package:my_car/functions/status_code.dart';
import 'package:my_car/values/strings.dart';
import 'package:my_car/views/my_progress_indicator.dart';

final fun = Functions();

class AskPage extends StatefulWidget {
  @override
  _AskPageState createState() => _AskPageState();
}

class _AskPageState extends State<AskPage> {
  StatusCode _submitStatus;
  @override
  Widget build(BuildContext context) {
    var _mController = TextEditingController();

    final snackBar = SnackBar(
      content: Text(errorMessage),
    );

    _submitQuestion(BuildContext context) async {
      //todo handle asked question
      //todo receive the error message then status code is 'failed'
      var question = _mController.text.trim();
      if (question.isNotEmpty) {
        setState(() {
          _submitStatus = StatusCode.waiting;
        });
        StatusCode statusCode = await fun.submitQuestion(question);
        setState(() {
          _submitStatus = statusCode;
        });
        statusCode == StatusCode.success
            ? Navigator.pop(context)
            : Scaffold.of(context).showSnackBar(snackBar);
      }
    }

    var _questionField = Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: TextField(
            controller: _mController,
            maxLines: 20,
            decoration:
            InputDecoration(border: InputBorder.none, hintText: askHint),
          ),
        ),
      ),
    );

    var _actions = ButtonBar(
      children: <Widget>[
        RaisedButton(
          color: Color(0xFF1A1A1A),
          onPressed: () =>
          _submitStatus == StatusCode.waiting
              ? null
              : _submitQuestion(context),
          child: _submitStatus == StatusCode.waiting
              ? MyProgressIndicator(
            size: 15.0,
            color: Colors.blue,
                )
              : Text(submitText, style: TextStyle(color: Colors.white)),
        )
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(askText),
      ),
      body: Builder(builder: (context) {
        return Column(
          children: <Widget>[_questionField, _actions],
        );
      }),
    );
  }
}
