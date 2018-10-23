import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_car/models/user.dart';
import 'package:my_car/values/strings.dart';

final usersFun = User();

class Answer {
  String id, answer, userId, questionId;
  int createdAt, votes;

  Answer(
      {this.id,
      this.userId,
      this.answer,
      this.questionId,
      this.createdAt,
      this.votes});

  Answer.fromSnapshot(DocumentSnapshot document) {
    this.id = document.documentID;
    this.answer = document[ANSWER_FIELD];
    this.userId = document[USER_ID_FIELD];
    this.questionId = document[QUESTION_ID_FIELD];
    this.createdAt = document[CREATED_AT_FIELD];
    this.votes = document[VOTES_FIELD];
  }

  Answer getAnsFromSnapshots(AsyncSnapshot snapshots, int index) {
    DocumentSnapshot document = snapshots.data.documents[index];
    return Answer.fromSnapshot(document);
  }
}
