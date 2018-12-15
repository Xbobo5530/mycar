import 'package:flutter/material.dart';
import 'package:my_car/src/models/main_model.dart';
import 'package:my_car/src/models/question.dart';
import 'package:my_car/src/pages/login.dart';
import 'package:my_car/src/utils/status_code.dart';
import 'package:my_car/src/utils/strings.dart';
import 'package:my_car/src/views/labeled_flat_button.dart';
import 'package:my_car/src/views/my_progress_indicator.dart';
import 'package:scoped_model/scoped_model.dart';

const _tag = 'FollowButtonView:';

class FollowButtonView extends StatefulWidget {
  final Question question;

  FollowButtonView({Key key, this.question}) : super(key: key);
  @override
  _FollowButtonViewState createState() => _FollowButtonViewState();
}

class _FollowButtonViewState extends State<FollowButtonView> {
  StatusCode _handlingFollowQuestionStatus;
  bool _isDisposed = false;
  @override
  Widget build(BuildContext context) {
    _goToLoginPage() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return LoginPage();
          });
    }

    _followQuestion(BuildContext context, MainModel model) async {
      if (!_isDisposed)
        setState(() {
          _handlingFollowQuestionStatus = StatusCode.waiting;
        });
      if (!model.isLoggedIn)
        _goToLoginPage();
      else {
        StatusCode statusCode = await model.handleFollowQuestion(
            widget.question, model.currentUser.id);
        if (statusCode == StatusCode.failed)
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(errorMessage),
          ));

        if (!_isDisposed)
          setState(() {
            _handlingFollowQuestionStatus = statusCode;
          });
      }
    }

    _getIsFollowing(MainModel model) async {}

    return ScopedModelDescendant<MainModel>(builder: (_, __, model) {
      return FutureBuilder<bool>(
          initialData: false,
          future: model.isUserFollowing(widget.question, model.currentUser),
          builder: (context, snapshot) {
            var isFollowing = snapshot.data;
            _getIsFollowing(model);
//            print('$_tag isFollowing is : $isFollowing');
            return Builder(
              builder: (context) {
                return LabeledFlatButton(
                    icon: _handlingFollowQuestionStatus == StatusCode.waiting
                        ? MyProgressIndicator(
                            size: 15.0,
                            color: isFollowing ? Colors.blue : Colors.grey,
                          )
                        : Icon(Icons.rss_feed,
                            size: 18.0,
                            color: isFollowing ? Colors.blue : Colors.grey),
                    label: Text(isFollowing ? followingText : followText,
                        style: TextStyle(
                            color: isFollowing ? Colors.blue : Colors.grey)),
                    onTap: () => _followQuestion(context, model));
              },
            );
          });
    });
  }
}
