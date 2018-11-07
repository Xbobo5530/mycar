import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_car/functions/functions.dart';
import 'package:my_car/utils/consts.dart';
import 'package:my_car/utils/strings.dart';

const tag = 'Question';
final fun = Functions();

class Question {
  String id, userId, createdBy, question;
  int createdAt;

  Question({@required this.question,
    @required this.id,
    this.userId,
    @required this.createdBy,
    @required this.createdAt});

  Question.fromSnapshot(DocumentSnapshot document)
      : this.question = document[QUESTION_FIELD],
        this.userId = document[USER_ID_FIELD],
        this.createdBy = document[CREATED_BY_FIELD],
        this.createdAt = document[CREATED_AT_FIELD];
}
