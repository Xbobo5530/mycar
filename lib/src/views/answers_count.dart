import 'package:flutter/material.dart';
import 'package:my_car/src/models/main_model.dart';
import 'package:my_car/src/models/question.dart';
import 'package:my_car/src/utils/colors.dart';
import 'package:my_car/src/views/my_progress_indicator.dart';
import 'package:scoped_model/scoped_model.dart';

class AnswersCountView extends StatelessWidget {
  final Question question;

  AnswersCountView({@required this.question});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (_, __, model) {
      return StreamBuilder(
        stream: model.answersStreamFor(question),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData)
            return MyProgressIndicator(
              color: Colors.black12,
              size: 15.0,
            );

          final answersCount = snapshot.data.documents.length;
          return answersCount == 0
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Chip(
                    label: Text('$answersCount',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: darkColor)),
                  ),
                );
        },
      );
    });
  }
}
