import 'package:flutter/material.dart';
import 'package:my_car/models/main_model.dart';
import 'package:my_car/models/question.dart';
import 'package:my_car/pages/view_question.dart';
import 'package:my_car/views/question_item.dart';
import 'package:scoped_model/scoped_model.dart';

class ForumPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (_, __, model) {
        return StreamBuilder(
            stream: model.questionsStream(),
            builder: (_, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (_, index) {
                    final document = snapshot.data.documents[index];
                    final question = Question.fromSnapshot(document);
                    return QuestionItemView(
                      key: Key(question.id),
                      question: question,
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  ViewQuestionPage(question: question))),
                    );
                  });
            });
      },
    );
  }
}