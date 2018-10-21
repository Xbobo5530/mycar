import 'package:flutter/material.dart';
import 'package:my_car/models/answer.dart';
import 'package:my_car/models/question.dart';
import 'package:my_car/values/strings.dart';
import 'package:my_car/views/answer_item.dart';
import 'package:my_car/views/question_item.dart';

final ansFun = Answer();

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
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (_, index) {
                    var answer = ansFun.getQnFromSnapshots(snapshot, index);

                    if (index == 0)
                      return Column(
                        children: <Widget>[
                          QuestionItemView(
                            question: widget.question,
                            source: 'ViewQuestionPage',
                          ),
                          Divider(),
                          AnswerItemView(
                            answer: answer,
                          )
                        ],
                      );
                    else
                      return AnswerItemView(
                        answer: answer,
                      );
                  });
            }));
  }
}
