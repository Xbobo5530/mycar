import 'package:flutter/material.dart';
import 'package:my_car/models/answer.dart';
import 'package:my_car/models/main_model.dart';
import 'package:my_car/pages/login.dart';
import 'package:my_car/utils/status_code.dart';
import 'package:my_car/utils/strings.dart';
import 'package:my_car/views/my_progress_indicator.dart';
import 'package:my_car/views/upvote_count.dart';
import 'package:scoped_model/scoped_model.dart';

class UpvoteButtonView extends StatelessWidget {
  final Answer answer;

  UpvoteButtonView({@required this.answer});

  @override
  Widget build(BuildContext context) {
    _goToLoginPage() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return LoginPage();
          });
    }

    _handleUpvoteAnswer(BuildContext context, MainModel model) async {
      if (!model.isLoggedIn)
        _goToLoginPage();
      else {
        StatusCode statusCode =
        await model.handleUpvoteAnswer(answer, model.currentUser.id);

        if (statusCode == StatusCode.failed)
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(errorMessage),
          ));
      }
    }

    return ScopedModelDescendant<MainModel>(
      builder: (_, __, MainModel model) {
        return model.handlingUpvoteAnswerStatus == StatusCode.waiting
            ? FutureBuilder<bool>(
          initialData: false,
          future: model.userHasUpvoted(answer, model.currentUser),
          builder: (_, snapshot) {
            bool _hasUpvoted = snapshot.data;
            return Chip(
              avatar: MyProgressIndicator(
                size: 15.0,
                color: _hasUpvoted ? Colors.blue : Colors.grey,
              ),
              label: Text(
                _hasUpvoted ? upvotedText : upvoteText,
                style: TextStyle(
                    color: _hasUpvoted ? Colors.blue : Colors.grey),
              ),
            );
          },
        )
            : Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () => _handleUpvoteAnswer(context, model),
              child: FutureBuilder<bool>(
                initialData: false,
                future: model.userHasUpvoted(answer, model.currentUser),
                builder: (_, snapshot) {
                  bool _hasUpvoted = snapshot.data;
                  return Chip(
                      avatar: _hasUpvoted
                          ? Icon(
                        Icons.done,
                        size: 20.0,
                        color: Colors.blue,
                      )
                          : Icon(Icons.thumb_up, color: Colors.grey),
                      label: Row(
                        children: <Widget>[
                          Text(
                            _hasUpvoted ? '' : upvoteText,
                            style: TextStyle(
                                color: _hasUpvoted
                                    ? Colors.blue
                                    : Colors.grey),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: UpvoteCountView(answer: answer),
                          ),
                        ],
                      ));
                },
              ),
            );
          },
        );
      },
    );
  }
}
