import 'package:flutter/material.dart';
import 'package:my_car/models/answer.dart';
import 'package:my_car/models/main_model.dart';
import 'package:my_car/models/question.dart';
import 'package:my_car/models/user.dart';
import 'package:my_car/utils/strings.dart';
import 'package:my_car/views/answer_item.dart';
import 'package:scoped_model/scoped_model.dart';

const tag = 'ViewQuestionPage';

class ViewQuestionPage extends StatelessWidget {
  final Question question;

  ViewQuestionPage({@required this.question});

  @override
  Widget build(BuildContext context) {
    final createdBy =
    question.createdBy != null ? question.createdBy : question.userId;
    final _userIcon = Icon(
      Icons.account_circle,
      color: Colors.grey,
      size: 18.0,
    );
    final _questionSection = Material(
      elevation: 4.0,
      child: ExpansionTile(
        leading: ScopedModelDescendant<MainModel>(
          builder: (_, __, model) {
            return FutureBuilder<User>(
                future: model.getUserFromUserId(createdBy),
                builder: (_, snapshot) {
                  if (!snapshot.hasData) return _userIcon;
                  final user = snapshot.data;
                  return user.imageUrl != null
                      ? CircleAvatar(
                    backgroundColor: Colors.black12,
                    backgroundImage: NetworkImage(user.imageUrl),
                  )
                      : _userIcon;
                });
          },
        ),
        title: Text('${question.question.substring(0, 35)}...'),
        children: <Widget>[
          ListTile(
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                question.question,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
            ),
          )
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
