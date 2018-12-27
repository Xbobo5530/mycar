import 'package:flutter/material.dart';
import 'package:my_car/src/models/scope_models/main_model.dart';
import 'package:my_car/src/models/question.dart';
import 'package:my_car/src/pages/view_question.dart';
import 'package:my_car/src/views/question_item.dart';
import 'package:scoped_model/scoped_model.dart';

class ForumPage extends StatelessWidget {
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
                    return FutureBuilder<Question>(
                      initialData: question,
                      future: model.refineQuestion(question),
                      builder: (context, snapshot)=>QuestionItemView(
                        key: Key(question.id),
                        question: snapshot.data,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  ViewQuestionPage(question: snapshot.data)))
                      ),
                    );
                    // return QuestionItemView(
                    //   key: Key(question.id),
                    //   question: question,
                    //   onTap: () => Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (_) =>
                    //               ViewQuestionPage(question: question))),
                    // );
                  });
            });
      },
    );
  }
}
