import 'package:flutter/material.dart';
import 'package:my_car/functions/functions.dart';
import 'package:my_car/models/answer.dart';
import 'package:my_car/utils/strings.dart';
import 'package:my_car/views/my_progress_indicator.dart';

const tag = 'UpvoteCountView';
final fun = Functions();

class UpvoteCountView extends StatelessWidget {
  final Answer answer;

  UpvoteCountView({this.answer});

  @override
  Widget build(BuildContext context) {
    var _data = fun.database
        .collection(QUESTIONS_COLLECTION)
        .document(answer.questionId)
        .collection(ANSWERS_COLLECTION)
        .document(answer.id)
        .collection(UPVOTES_COLLECTION)
        .snapshots();

    return StreamBuilder(
      stream: _data,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
          case ConnectionState.active:
            switch (snapshot.hasData) {
              case true:
                var upvotesCount = snapshot.data.documents.length;
                if (upvotesCount > 0)
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text('$upvotesCount',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A))),
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
