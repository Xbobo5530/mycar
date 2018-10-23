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

class ViewQuestionPage extends StatelessWidget {
  final Question question;

  ViewQuestionPage({this.question});

  @override
  Widget build(BuildContext context) {
    var _data = fun.database
        .collection(QUESTIONS_COLLECTION)
        .document(question.id)
        .collection(ANSWERS_COLLECTION)
        .snapshots();
    return Scaffold(
        appBar: AppBar(
          title: Text(questionText),
        ),
        body: Column(
          children: <Widget>[
            QuestionItemView(
              question: question,
              source: 'ViewQuestionPage',
            ),
            Expanded(
              child: StreamBuilder(
                  stream: _data,
                  builder: (_, snapshot) {
                    if (!snapshot.hasData)
                      return Center(
                          child: Center(child: CircularProgressIndicator()));

                    return ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (_, index) {
                          var answer =
                              ansFun.getAnsFromSnapshots(snapshot, index);
                          return AnswerItemView(
                            answer: answer,
                          );
                        });
                  }),
            ),
          ],
        ));
  }
}
