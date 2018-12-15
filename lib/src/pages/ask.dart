import 'package:flutter/material.dart';
import 'package:my_car/src/models/main_model.dart';
import 'package:my_car/src/utils/colors.dart';
import 'package:my_car/src/utils/status_code.dart';
import 'package:my_car/src/utils/strings.dart';
import 'package:my_car/src/views/my_progress_indicator.dart';
import 'package:scoped_model/scoped_model.dart';

const _tag = 'AskPage';

class AskPage extends StatefulWidget {
  @override
  AskPageState createState() {
    return AskPageState();
  }
}

class AskPageState extends State<AskPage> {
  final _mController = TextEditingController();

  @override
  void dispose() {
    _mController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snackBar = SnackBar(
      content: Text(errorMessage),
    );

    _submitQuestion(BuildContext context, MainModel model) async {
      //todo receive the error message then status code is 'failed'
      final question = _mController.text.trim();
      if (question.isNotEmpty) {
        StatusCode statusCode =
            await model.submitQuestion(question, model.currentUser.id);

        switch (statusCode) {
          case StatusCode.success:
            Navigator.pop(context);
            break;
          case StatusCode.failed:
            Scaffold.of(context).showSnackBar(snackBar);
            break;
          default:
            print('$_tag the submit question status code is $statusCode');
        }
      }
    }

    final _questionField = Expanded(
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

    final _actions = ButtonBar(
      children: <Widget>[
        ScopedModelDescendant<MainModel>(
          builder: (_, __, model) {
            return RaisedButton(
              color: darkColor,
              onPressed: () =>
                  model.submittingQuestionStatus == StatusCode.waiting
                      ? null
                      : _submitQuestion(context, model),
              child: model.submittingQuestionStatus == StatusCode.waiting
                  ? MyProgressIndicator(
                      size: 15.0,
                      color: Colors.white,
                    )
                  : Text(submitText, style: TextStyle(color: Colors.white)),
            );
          },
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
