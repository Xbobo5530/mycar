import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_car/utils/consts.dart';

class Question {
  String id, userId, createdBy, question;
  int createdAt;

  Question(
      {@required this.question,
      @required this.id,
      this.userId,
      this.createdBy,
      @required this.createdAt});

  Question.fromSnapshot(DocumentSnapshot document)
      : this.id = document.documentID,
        this.question = document[QUESTION_FIELD],
        this.userId = document[USER_ID_FIELD],
        this.createdBy = document[CREATED_BY_FIELD],
        this.createdAt = document[CREATED_AT_FIELD];
}
