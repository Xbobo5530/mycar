import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_car/functions/login_fun.dart';
import 'package:my_car/models/question.dart';
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

    /// create question map
    Map<String, dynamic> questionMap = {
      USER_ID_FIELD: _userId,
      QUESTION_FIELD: question,
      CREATED_AT_FIELD: DateTime.now().millisecondsSinceEpoch
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

  Future<StatusCode> submitAnswer(Question question, String answer) async {
    var _hasError = false;

    /// get user details
    var _userId = await usersFun.getUserId();

    /// create answer map
    Map<String, dynamic> answerMap = {
      USER_ID_FIELD: _userId,
      ANSWER_FIELD: answer,
      QUESTION_ID: question.id,
      CREATED_AT_FIELD: DateTime.now().millisecondsSinceEpoch
    };

    /// add answer to question on database
    await database
        .collection(QUESTIONS_COLLECTION)
        .document(question.id)
        .collection(ANSWERS_COLLECTION)
        .add(answerMap)
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
