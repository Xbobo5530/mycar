import 'package:flutter/material.dart';
import 'package:my_car/models/answer.dart';
import 'package:my_car/models/main_model.dart';
import 'package:my_car/models/question.dart';
import 'package:my_car/utils/strings.dart';
import 'package:my_car/views/answer_item.dart';
import 'package:my_car/views/question_item.dart';
import 'package:scoped_model/scoped_model.dart';

const tag = 'ViewQuestionPage';

class ViewQuestionPage extends StatelessWidget {
  final Question question;

  ViewQuestionPage({@required this.question});

  @override
  Widget build(BuildContext context) {
    final _questionSection = QuestionItemView(
      question: question,
    );

    var _answersSection = ScopedModelDescendant<MainModel>(
      builder: (_, __, model) {
        return StreamBuilder(
            stream: model.answersStreamFor(question),
            builder: (_, snapshot) {
              if (!snapshot.hasData)
                return Center(
                    child: Center(child: CircularProgressIndicator()));

              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (_, index) {
                    final document = snapshot.data.documents[index];
                    final answer = Answer.fromSnapshot(document);
                    return AnswerItemView(
                      answer: answer,
                    );
                  });
            });
      },
    );

    return Scaffold(
        appBar: AppBar(
          title: Text(questionText),
          elevation: 0.0,
        ),
        body: Column(
          children: <Widget>[
            _questionSection,
            Expanded(child: _answersSection),
          ],
        ));
  }
}
