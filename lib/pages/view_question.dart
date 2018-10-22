import 'package:flutter/material.dart';
import 'package:my_car/functions/functions.dart';
import 'package:my_car/models/answer.dart';
import 'package:my_car/models/question.dart';
import 'package:my_car/values/strings.dart';
import 'package:my_car/views/answer_item.dart';
import 'package:my_car/views/question_item.dart';

const tag = 'ViewQuestionPage';
final ansFun = Answer();
final fun = Functions();

class ViewQuestionPage extends StatefulWidget {
  final Question question;

  ViewQuestionPage({this.question});

  @override
  _ViewQuestionPageState createState() => _ViewQuestionPageState();
}

class _ViewQuestionPageState extends State<ViewQuestionPage> {
  var _data;

  @override
  void initState() {
    _data = fun.database
        .collection(QUESTIONS_COLLECTION)
        .document(widget.question.id)
        .collection(ANSWERS_COLLECTION)
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(questionText),
        ),
        body: StreamBuilder(
            stream: _data,
            builder: (_, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());

              return Column(
                children: <Widget>[
                  Card(
                    child: QuestionItemView(
                      question: widget.question,
                      source: 'ViewQuestionPage',
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (_, index) {
                          var answer =
                          ansFun.getAnsFromSnapshots(snapshot, index);
                          return AnswerItemView(
                            answer: answer,
                          );
                        }),
                  )
                ],
              );
            }));
  }
}
