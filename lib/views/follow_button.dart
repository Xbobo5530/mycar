import 'package:flutter/material.dart';
import 'package:my_car/models/main_model.dart';
import 'package:my_car/models/question.dart';
import 'package:my_car/pages/login.dart';
import 'package:my_car/utils/status_code.dart';
import 'package:my_car/utils/strings.dart';
import 'package:my_car/views/labeled_flat_button.dart';
import 'package:my_car/views/my_progress_indicator.dart';
import 'package:scoped_model/scoped_model.dart';

const _tag = 'FollowButtonView:';

class FollowButtonView extends StatefulWidget {
  final Question question;

  FollowButtonView({@required this.question, Key key}) : super(key: key);

  @override
  _FollowButtonViewState createState() => _FollowButtonViewState();
}

class _FollowButtonViewState extends State<FollowButtonView> {
  StatusCode _handlingFollowQuestionStatus;
  bool _isFollowing = false;
  bool _isDisposed = false;

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

    _followQuestion(BuildContext context, MainModel model) async {
      if (!model.isLoggedIn)
        _goToLoginPage();
      else {
        if (!_isDisposed)
          setState(() {
            _handlingFollowQuestionStatus = StatusCode.waiting;
          });
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

    return ScopedModelDescendant<MainModel>(builder: (_, __, model) {
      return FutureBuilder<bool>(
          initialData: false,
          future: model.isUserFollowing(widget.question, model.currentUser),
          builder: (context, snapshot) {
            final isFollowing = snapshot.data;
            print('$_tag isFollowing is : $isFollowing');
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
