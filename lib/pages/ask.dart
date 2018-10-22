import 'package:flutter/material.dart';
import 'package:my_car/functions/functions.dart';
import 'package:my_car/functions/status_code.dart';
import 'package:my_car/values/strings.dart';

final fun = Functions();

class AskPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _mController = TextEditingController();

    final snackBar = SnackBar(
      content: Text('Yay! A SnackBar!'),
    );

    _submitQuestion(BuildContext context) async {
      //todo handle asked question
      //todo receive the error message then status code is 'failed'
      var question = _mController.text.trim();
      if (question.isNotEmpty) {
        StatusCode statusCode = await fun.submitQuestion(question);
        statusCode == StatusCode.success
            ? Navigator.pop(context)
            : Scaffold.of(context).showSnackBar(snackBar);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(askText),
      ),
      body: Builder(builder: (context) {
        return Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: TextField(
                    controller: _mController,
                    maxLines: 20,
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: askHint),
                  ),
                ),
              ),
            ),
            ButtonBar(
              children: <Widget>[
                RaisedButton(
                  color: Colors.cyan,
                  onPressed: () => _submitQuestion(context),
                  child: Text(submitText),
                )
              ],
            )
          ],
        );
      }),
    );
  }
}
