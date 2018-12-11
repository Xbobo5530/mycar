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
        this.answer = document[FIELD_ANSWER],
        this.userId = document[FIELD_USER_ID],
        this.createdBy = document[FIELD_CREATED_BY],
        this.questionId = document[FIELD_QUESTION_ID],
        this.createdAt = document[FIELD_CREATED_AT],
        this.votes = document[FIELD_VOTES];
}
