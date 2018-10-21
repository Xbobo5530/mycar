import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/async.dart';
import 'package:my_car/functions/functions.dart';
import 'package:my_car/values/strings.dart';

const tag = 'Question';
final fun = Functions();

class Question {
  String id, userId, question;
  int createdAt;

  Question({this.question, this.id, this.userId, this.createdAt});

  Question.fromSnapshot(DocumentSnapshot document) {
    this.id = document.documentID;
    this.question = document[QUESTION_FIELD];
    this.userId = document[USER_ID_FIELD];
    this.createdAt = document[CREATED_AT_FIELD];
  }

  var _cachedQuestionsSnapshot;

  Stream<QuerySnapshot> getQuestionsStream() {
    if (_cachedQuestionsSnapshot == null)
      return _cachedQuestionsSnapshot;
    else {
      _cachedQuestionsSnapshot =
          fun.database.collection(QUESTIONS_COLLECTION).snapshots();
      return _cachedQuestionsSnapshot;
    }
  }

  Question getQnFromSnapshots(AsyncSnapshot snapshots, int index) {
    DocumentSnapshot document = snapshots.data.documents[index];
    return Question.fromSnapshot(document);
  }
}
