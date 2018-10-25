import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_car/functions/functions.dart';
import 'package:my_car/functions/login_fun.dart';
import 'package:my_car/models/main_scopped_model.dart';
import 'package:my_car/models/question.dart';
import 'package:my_car/models/user.dart';
import 'package:my_car/pages/ask.dart';
import 'package:my_car/pages/login.dart';
import 'package:my_car/pages/user_profile.dart';
import 'package:my_car/values/strings.dart';
import 'package:my_car/views/question_item.dart';
import 'package:scoped_model/scoped_model.dart';

const tag = 'HomePage:';
final fun = Functions();
final loginFun = LoginFunctions();
final qnFun = Question();

final userFun = User();

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> _data = fun.database
        .collection(QUESTIONS_COLLECTION)
        .orderBy(CREATED_AT_FIELD, descending: true)
        .snapshots();

    _goToProfilePage() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return ScopedModelDescendant<MyCarModel>(
              builder: (BuildContext context, Widget child, MyCarModel model) {
                return UserProfilePage(
                    user: model.currentUser, isCurrentUser: true);
              },
            );
          });
    }

    _goToLoginPage() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return LoginPage();
          });
    }

    _goToAskQuestionPage() {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => AskPage(), fullscreenDialog: true));
    }

    var _askQuestionSection = ScopedModelDescendant<MyCarModel>(
      builder: (BuildContext context, Widget child, MyCarModel model) {
        return IconButton(
            icon: Icon(Icons.add),
            onPressed: model.isLoggedIn
                ? () => _goToAskQuestionPage()
                : () => _goToLoginPage());
      },
    );

    var _currentUserProfileSection = Padding(
      padding: const EdgeInsets.all(8.0),
      child: ScopedModelDescendant<MyCarModel>(
        builder: (BuildContext context, Widget child, MyCarModel model) {
          return IconButton(
            onPressed: model.isLoggedIn
                ? () => _goToProfilePage()
                : () => _goToLoginPage(),
            icon: model.currentUser != null &&
                model.currentUser.imageUrl != null
                ? CircleAvatar(
                    radius: 12.0,
                backgroundImage: NetworkImage(model.currentUser.imageUrl))
                : Icon(
                    Icons.account_circle,
                    size: 30.0,
                    color: Colors.grey,
                  ),
          );
        },
      ),
    );

    var _bodySection = StreamBuilder(
        stream: _data,
        builder: (_, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (_, index) {
                var question = qnFun.getQnFromSnapshots(snapshot, index);
                return QuestionItemView(
                  question: question,
                  source: 'HomePage',
                );
              });
        });

    return Scaffold(
        appBar: AppBar(
          title: Text(APP_NAME),
          leading: _askQuestionSection,
          actions: <Widget>[
            _currentUserProfileSection,
          ],
        ),
        body: _bodySection);
  }
}
