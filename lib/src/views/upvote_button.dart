import 'package:flutter/material.dart';
import 'package:my_car/src/models/answer.dart';
import 'package:my_car/src/models/scope_models/main_model.dart';
import 'package:my_car/src/pages/login.dart';
import 'package:my_car/src/utils/status_code.dart';
import 'package:my_car/src/utils/strings.dart';
import 'package:my_car/src/views/my_progress_indicator.dart';
import 'package:my_car/src/views/upvote_count.dart';
import 'package:scoped_model/scoped_model.dart';

class UpvoteButtonView extends StatefulWidget {
  final Answer answer;

  UpvoteButtonView({@required this.answer});

  @override
  _UpvoteButtonViewState createState() => _UpvoteButtonViewState();
}

class _UpvoteButtonViewState extends State<UpvoteButtonView> {
  bool _isDisposed = false;
  StatusCode _handlingUpvoteAnswerStatus;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

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
        if (!_isDisposed)
          setState(() {
            _handlingUpvoteAnswerStatus = StatusCode.waiting;
          });
        StatusCode statusCode =
            await model.handleUpvoteAnswer(widget.answer, model.currentUser.id);

        if (statusCode == StatusCode.failed)
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(errorMessage),
          ));
        if (!_isDisposed)
          setState(() {
            _handlingUpvoteAnswerStatus = statusCode;
          });
      }
    }

    Widget _buildDisabledUpvoteButton(bool hasUpvoted) {
      return Chip(
        avatar: MyProgressIndicator(
          size: 15.0,
          color: hasUpvoted ? Colors.blue : Colors.grey,
        ),
        label: Text(
          hasUpvoted ? upvotedText : upvoteText,
          style: TextStyle(color: hasUpvoted ? Colors.blue : Colors.grey),
        ),
      );
    }

    Widget _buildEnabledUpvoteButton(BuildContext context, MainModel model) {
      return FutureBuilder<bool>(
        initialData: false,
        future: model.userHasUpvoted(widget.answer, model.currentUser),
        builder: (_, snapshot) {
          bool _hasUpvoted = snapshot.data;
          return ActionChip(
            padding: const EdgeInsets.all(0.0),
//            labelPadding: const EdgeInsets.only(left: 0.0),
            avatar: _hasUpvoted
                ? Icon(
                    Icons.done,
                    size: 20.0,
                    color: Colors.blue,
                  )
                : Icon(
                    Icons.thumb_up,
                    color: Colors.grey,
                    size: 20.0,
                  ),
            label: Row(
              children: <Widget>[
                _hasUpvoted
                    ? Container(
                        height: 0.0,
                        width: 0.0,
                      )
                    : Text(
                        upvoteText,
                        style: TextStyle(
                          color: _hasUpvoted ? Colors.blue : Colors.grey,
                        ),
                      ),
                UpvoteCountView(answer: widget.answer),
              ],
            ),
            onPressed: () => _handleUpvoteAnswer(context, model),
          );
        },
      );
    }

    Widget _disabledUpvoteButton(MainModel model) => FutureBuilder<bool>(
          initialData: false,
          future: model.userHasUpvoted(widget.answer, model.currentUser),
          builder: (_, snapshot) {
            bool _hasUpvoted = snapshot.data;
            return _buildDisabledUpvoteButton(_hasUpvoted);
          },
        );

    Widget _enabledUpvoteButton(MainModel model) => Builder(
          builder: (context) {
            return _buildEnabledUpvoteButton(context, model);
          },
        );

    return ScopedModelDescendant<MainModel>(
      builder: (_, __, MainModel model) {
        return _handlingUpvoteAnswerStatus == StatusCode.waiting
            ? _disabledUpvoteButton(model)
            : _enabledUpvoteButton(model);
      },
    );
  }
}
