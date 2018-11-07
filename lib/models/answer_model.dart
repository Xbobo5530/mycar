import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_car/models/account_model.dart';
import 'package:my_car/models/answer.dart';
import 'package:my_car/models/question.dart';
import 'package:my_car/utils/consts.dart';
import 'package:my_car/utils/status_code.dart';

const _tag = 'AnswerModel:';

abstract class AnswerModel with AccountModel {
  final _database = Firestore.instance;

  Future<StatusCode> submitAnswer(
      Question question, String answer, String userId) async {
    print('$tag at submitAnswer');
    var _hasError = false;

    Map<String, dynamic> answerMap = {
      CREATED_BY_FIELD: userId,
      ANSWER_FIELD: answer,
      QUESTION_ID: question.id,
      CREATED_AT_FIELD: DateTime.now().millisecondsSinceEpoch
    };

    await _database
        .collection(QUESTIONS_COLLECTION)
        .document(question.id)
        .collection(ANSWERS_COLLECTION)
        .add(answerMap)
        .catchError((error) {
      print('$tag error on submitting question $error');
      _hasError = true;
    });

    if (_hasError) return StatusCode.failed;
    return StatusCode.success;
  }

  Future<StatusCode> handleUpvoteAnswer(Answer answer, String userId) async {
    print('$_tag at upvoteAnswer');
    var _hasError = false;

    DocumentReference upvoteDocRef = _getUpvoteDocumentRef(answer, userId);

    DocumentSnapshot document = await upvoteDocRef.get().catchError(((error) {
      print('$_tag error on upvoting answer: $error');
      _hasError = true;
    }));

    if (_hasError) return StatusCode.failed;

    if (document.exists)
      upvoteDocRef.delete().catchError((error) {
        print('$_tag error on deleting upvoted doc: $error');
        _hasError = true;
      });
    else {
      Map<String, dynamic> upvoteMap = {
        CREATED_BY_FIELD: userId,
        ANSWER_ID_FIELD: answer.id,
        QUESTION_ID_FIELD: answer.questionId,
        CREATED_AT_FIELD: DateTime.now().millisecondsSinceEpoch
      };
      upvoteDocRef.setData(upvoteMap).catchError((error) {
        print('$_tag error on adding upvote: $error');
        _hasError = true;
      });
    }

    if (_hasError) return StatusCode.failed;
    return StatusCode.success;
  }

  Future<bool> userHasUpvoted(Answer answer, String userId) async {
    print('$_tag at userHasUpvoted');
    bool _hasError = false;

    DocumentReference upvoteDocRef = _getUpvoteDocumentRef(answer, userId);
    DocumentSnapshot document = await upvoteDocRef.get().catchError((error) {
      print('$_tag error on getting document for checking user upvote');
      _hasError = true;
    });
    if (!document.exists || !_hasError) return false;
    return true;
  }

  DocumentReference _getUpvoteDocumentRef(Answer answer, String userId) {
    return _database
        .collection(QUESTIONS_COLLECTION)
        .document(answer.questionId)
        .collection(ANSWERS_COLLECTION)
        .document(answer.id)
        .collection(UPVOTES_COLLECTION)
        .document(userId);
  }
}
