import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_car/functions/login_fun.dart';
import 'package:my_car/models/user.dart';
import 'package:my_car/values/strings.dart';

const tag = 'Functions';
final loginFun = LoginFunctions();
final usersFun = User();

class Functions {
  var database = Firestore.instance;

  Future<StatusCode> submitQuestion(String question) async {
    var _hasError = false;

    /// get user details
    var _userId = await usersFun.getUserId();

    /// create user map
    Map<String, dynamic> questionMap = {
      'user_id': _userId,
      'question': question,
      'created_ad': DateTime
          .now()
          .millisecondsSinceEpoch
    };

    /// add question to database
    await database
        .collection(QUESTIONS_COLLECTION)
        .add(questionMap)
        .catchError((error) {
      print('$tag error on submitting question $error');
      _hasError = true;
    });

    if (_hasError)
      return StatusCode.failed;
    else
      return StatusCode.success;
  }
}

enum StatusCode { failed, waiting, success }
