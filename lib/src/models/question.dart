import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_car/src/utils/consts.dart';

class Question {
  String id, userId, createdBy, question, username,userImageUrl;
  int createdAt;

  Question(
      {this.id,
      @required this.question,
      this.userId,
      this.createdBy,
      this.username, 
      this.userImageUrl,
      @required this.createdAt});

  Question.fromSnapshot(DocumentSnapshot document)
      : this.id = document.documentID,
        this.question = document[FIELD_QUESTION],
        this.userId = document[FIELD_USER_ID],
        this.createdBy = document[FIELD_CREATED_BY],
        this.createdAt = document[FIELD_CREATED_AT];
}
