import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_car/models/user.dart';
import 'package:my_car/utils/consts.dart';

final usersFun = User();

class Answer {
  String id, answer, createdBy, userId, questionId;
  int createdAt, votes;

  Answer(
      {this.id,
      this.userId,
        this.createdBy,
      this.answer,
      this.questionId,
      this.createdAt,
      this.votes});

  Answer.fromSnapshot(DocumentSnapshot document)
      : this.id = document.documentID,
        this.answer = document[ANSWER_FIELD],
        this.userId = document[USER_ID_FIELD],
        this.createdBy = document[CREATED_BY_FIELD],
        this.questionId = document[QUESTION_ID_FIELD],
        this.createdAt = document[CREATED_AT_FIELD],
        this.votes = document[VOTES_FIELD];
}
