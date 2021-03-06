import 'package:flutter/material.dart';
import 'package:my_car/src/models/answer.dart';
import 'package:my_car/src/models/scope_models/main_model.dart';
import 'package:my_car/src/models/question.dart';
import 'package:my_car/src/models/user.dart';
import 'package:my_car/src/utils/strings.dart';
import 'package:my_car/src/views/answer_item.dart';
import 'package:my_car/src/views/heading_section.dart';
import 'package:my_car/src/views/question_actions.dart';
import 'package:scoped_model/scoped_model.dart';

const tag = 'ViewQuestionPage';

class ViewQuestionPage extends StatelessWidget {
  final Question question;

  const ViewQuestionPage({Key key, @required this.question}) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    final createdBy =
        question.createdBy != null ? question.createdBy : question.userId;
    // final _userIcon = Icon(
    //   Icons.account_circle,
    //   color: Colors.grey,
    //   size: 40.0,
    // );
    final _questionSection = Material(
      elevation: 4.0,
      child: Column(
        children: <Widget>[
          ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
              return FutureBuilder<User>(
                future: model.getUserFromUserId(createdBy),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  User userFromId = snapshot.data;
                  return HeadingSectionView(
                    imageUrl: userFromId.imageUrl,
                    heading: question.question,
                  );
                },
              );
            },
          ),
          QuestionActionsView(question: question,),
        ],
      ),
    );

    final _answersSection = ScopedModelDescendant<MainModel>(
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
