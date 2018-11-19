import 'package:flutter/material.dart';
import 'package:my_car/models/answer.dart';
import 'package:my_car/models/main_model.dart';
import 'package:my_car/utils/colors.dart';
import 'package:my_car/views/my_progress_indicator.dart';
import 'package:scoped_model/scoped_model.dart';

const tag = 'UpvoteCountView';

class UpvoteCountView extends StatelessWidget {
  final Answer answer;

  UpvoteCountView({this.answer});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (_, __, model) {
        return StreamBuilder(
          stream: model.upvotesStreamFor(answer),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData)
              return MyProgressIndicator(
                color: Colors.black12,
                size: 15.0,
              );

            final upvotesCount = snapshot.data.documents.length;
//            if (upvotesCount == 0) return Container();
            return Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text('$upvotesCount',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: darkColor)),
            );
          },
        );
      },
    );
  }
}
