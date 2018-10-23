import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_car/functions/login_fun.dart';
import 'package:my_car/functions/status_code.dart';
import 'package:my_car/models/answer.dart';
import 'package:my_car/models/question.dart';
import 'package:my_car/models/user.dart';
import 'package:my_car/values/strings.dart';

const tag = 'Functions';
final loginFun = LoginFunctions();
final usersFun = User();

class Functions {
  var database = Firestore.instance;

  Future<StatusCode> submitQuestion(String question) async {
    print('$tag at submitQuestion');
    var _hasError = false;

    /// get user details
    var _userId = await usersFun.getCurrentUserId();

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
    print('$tag at submitAnswer');
    var _hasError = false;

    /// get user details
    var _userId = await usersFun.getCurrentUserId();

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

  Future<StatusCode> upvoteAnswer(Answer answer) async {
    print('$tag at upvoteAnswer');
    var _hasError = false;

    /// get current user details
    var _userId = await usersFun.getCurrentUserId();

    DocumentReference upvoteDocRef = await getUpvoteDocumentRef(answer);

    /// check if user has already upvoted
    DocumentSnapshot document = await upvoteDocRef.get().catchError(((error) {
      print('$tag error on upvoting answer: $error');
      _hasError = true;
    }));
    if (document.exists) {
      /// user has already upvoted
      /// remove user doc from upvoted answer
      upvoteDocRef.delete().catchError((error) {
        print('$tag error on deleting upvoted doc: $error');
        _hasError = true;
      });
    } else {
      /// user has not upvoted
      /// add user upvote
      /// create question map
      Map<String, dynamic> upvoteMap = {
        USER_ID_FIELD: _userId,
        ANSWER_ID_FIELD: answer.id,
        QUESTION_ID_FIELD: answer.questionId,
        CREATED_AT_FIELD: DateTime.now().millisecondsSinceEpoch
      };
      upvoteDocRef.setData(upvoteMap).catchError((error) {
        print('$tag error on adding upvote: $error');
        _hasError = true;
      });
    }

    if (_hasError)
      return StatusCode.failed;
    else
      return StatusCode.success;
  }

  Future<DocumentReference> getUpvoteDocumentRef(Answer answer) async {
    /// get current user details
    var _userId = await usersFun.getCurrentUserId();

    return database
        .collection(QUESTIONS_COLLECTION)
        .document(answer.questionId)
        .collection(ANSWERS_COLLECTION)
        .document(answer.id)
        .collection(UPVOTES_COLLECTION)
        .document(_userId);
  }

  Future<bool> userHasUpvoted(Answer answer) async {
    bool _hasError = false;

    ///get document reference for upvote
    DocumentReference upvoteDocRef = await getUpvoteDocumentRef(answer);

    /// get document and check if it exists
    DocumentSnapshot document = await upvoteDocRef.get().catchError((error) {
      print('$tag error on getting document for checking user upvote');
      _hasError = true;
    });
    if (document.exists && !_hasError)
      return true;
    else
      return false;
  }

  Future<DocumentReference> getFollowingDocumentRef(Question question) async {
    /// get current user details
    var _userId = await usersFun.getCurrentUserId();

    return database
        .collection(QUESTIONS_COLLECTION)
        .document(question.id)
        .collection(FOLLOWERS_COLLECTION)
        .document(_userId);
  }

  Future<StatusCode> followQuestion(Question question) async {
    print('$tag at followQuestion');
    var _hasError = false;

    /// get current user details
    var _userId = await usersFun.getCurrentUserId();

    DocumentReference followerDocRef = await getFollowingDocumentRef(question);

    /// check if user has already followed
    DocumentSnapshot document = await followerDocRef.get().catchError(((error) {
      print('$tag error on following question: $error');
      _hasError = true;
    }));
    if (document.exists) {
      /// user has already followed question
      /// remove user doc from followed question
      followerDocRef.delete().catchError((error) {
        print('$tag error on deleting followed question doc: $error');
        _hasError = true;
      });
    } else {
      /// user has not followed
      /// add user follow
      /// create follow map
      Map<String, dynamic> followMap = {
        USER_ID_FIELD: _userId,
        ANSWER_ID_FIELD: question.id,
        CREATED_AT_FIELD: DateTime.now().millisecondsSinceEpoch
      };
      followerDocRef.setData(followMap).catchError((error) {
        print('$tag error on adding follow: $error');
        _hasError = true;
      });
    }

    if (_hasError)
      return StatusCode.failed;
    else
      return StatusCode.success;
  }

  Future<bool> isUserFollowing(Question question) async {
    bool _hasError = false;

    bool _isLoggedIn = await loginFun.isLoggedIn();
    if (_isLoggedIn) {
      ///get document reference for follow
      DocumentReference followDocRef = await getFollowingDocumentRef(question);

      /// get document and check if it exists
      DocumentSnapshot document = await followDocRef.get().catchError((error) {
        print('$tag error on getting document for checking following status');
        _hasError = true;
      });
      if (document.exists && !_hasError)
        return true;
      else
        return false;
    } else {
      return false;
    }
  }
}
