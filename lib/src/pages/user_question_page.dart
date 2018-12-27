import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_car/src/models/question.dart';
import 'package:my_car/src/models/scope_models/main_model.dart';
import 'package:my_car/src/models/user.dart';
import 'package:my_car/src/pages/view_question.dart';
import 'package:my_car/src/utils/strings.dart';
import 'package:my_car/src/views/question_item.dart';
import 'package:scoped_model/scoped_model.dart';

class UserQuestinsPage extends StatelessWidget {
  final User user;

  const UserQuestinsPage({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) => Scaffold(
            appBar: AppBar(
              title: Text(model.isLoggedIn && (user.id == model.currentUser.id)
                  ? myQuestionsText
                  : questionsText),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: model.userQuestionsStream(user),
              builder: (context, snapshot) => !snapshot.hasData
                  ? Center(child: CircularProgressIndicator())
                  : snapshot.data.documents.length == 0
                      ? Center(
                          child: Text(noQuestionsText),
                        )
                      : ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            Question question = Question.fromSnapshot(
                                snapshot.data.documents[index]);
                            return QuestionItemView(
                              question: question,
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ViewQuestionPage(
                                            question: question,
                                          ))),
                              key: Key(question.id),
                            );
                          },
                        ),
            ),
          ),
    );
  }
}
