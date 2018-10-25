import 'package:flutter/material.dart';
import 'package:my_car/models/question.dart';
import 'package:my_car/values/strings.dart';
import 'package:my_car/views/my_progress_indicator.dart';

const tag = 'AnswersCountView:';

class AnswersCountView extends StatelessWidget {
  final Question question;

  AnswersCountView({this.question});

  @override
  Widget build(BuildContext context) {
    var _data = fun.database
        .collection(QUESTIONS_COLLECTION)
        .document(question.id)
        .collection(ANSWERS_COLLECTION)
        .snapshots();

    return StreamBuilder(
      stream: _data,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
          case ConnectionState.active:
            switch (snapshot.hasData) {
              case true:
                var answersCount = snapshot.data.documents.length;
                if (answersCount > 0)
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Chip(
                      label: Text('$answersCount',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A))),
                    ),
                  );
                else
                  return Container();
                break;
              default:
                return Container();
            }
            break;
          case ConnectionState.waiting:
            return MyProgressIndicator(
              color: Colors.black12,
              size: 15.0,
            );
          default:
            print('$tag at default');
            return Container();
        }
      },
    );
  }
}
