import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_car/models/account_model.dart';
import 'package:my_car/models/answer.dart';
import 'package:my_car/models/question.dart';
import 'package:my_car/models/user.dart';
import 'package:my_car/utils/consts.dart';
import 'package:my_car/utils/status_code.dart';

const _tag = 'AnswerModel:';

abstract class AnswerModel with AccountModel {
  final _database = Firestore.instance;

  StatusCode _submittingAnswerStatus;
  StatusCode get submittingAnswerStatus => _submittingAnswerStatus;

  StatusCode _handlingUpvoteAnswerStatus;
  StatusCode get handlingUpvoteAnswerStatus => _handlingUpvoteAnswerStatus;

  Stream<QuerySnapshot> answersStreamFor(Question question) {
    return _database
        .collection(QUESTIONS_COLLECTION)
        .document(question.id)
        .collection(ANSWERS_COLLECTION)
        .orderBy(CREATED_AT_FIELD, descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> upvotesStreamFor(Answer answer) {
    return _database
        .collection(QUESTIONS_COLLECTION)
        .document(answer.questionId)
        .collection(ANSWERS_COLLECTION)
        .document(answer.id)
        .collection(UPVOTES_COLLECTION)
        .snapshots();
  }

  Future<StatusCode> submitAnswer(
      Question question, String answer, String userId) async {
    print('$_tag at submitAnswer');
    _submittingAnswerStatus = StatusCode.waiting;
    notifyListeners();
    bool _hasError = false;

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
      print('$_tag error on submitting question $error');
      _hasError = true;
      _submittingAnswerStatus = StatusCode.failed;
      notifyListeners();
    });

    if (_hasError) return StatusCode.failed;
    _submittingAnswerStatus = StatusCode.success;
    notifyListeners();
    return _submittingAnswerStatus;
  }

  //todo check this method doesn't seem to be working

  Future<StatusCode> handleUpvoteAnswer(Answer answer, String userId) async {
    print('$_tag at upvoteAnswer');
    _handlingUpvoteAnswerStatus = StatusCode.waiting;
    notifyListeners();
    bool _hasError = false;

    DocumentReference upvoteDocRef = _getUpvoteDocumentRef(answer, userId);

    DocumentSnapshot document = await upvoteDocRef.get().catchError(((error) {
      print('$_tag error on upvoting answer: $error');
      _hasError = true;
      _handlingUpvoteAnswerStatus = StatusCode.failed;
      notifyListeners();
    }));

    if (_hasError) return _handlingUpvoteAnswerStatus;

    if (document.exists)
      upvoteDocRef.delete().catchError((error) {
        print('$_tag error on deleting upvoted doc: $error');
        _hasError = true;
        _handlingUpvoteAnswerStatus = StatusCode.failed;
        notifyListeners();
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
        _handlingUpvoteAnswerStatus = StatusCode.failed;
        notifyListeners();
      });
    }

    if (_hasError) return StatusCode.failed;
    _handlingUpvoteAnswerStatus = StatusCode.success;
    notifyListeners();
    return _handlingUpvoteAnswerStatus;
  }

  //todo check this method doesn't seem to be working
  Future<bool> userHasUpvoted(Answer answer, User user) async {
    print('$_tag at userHasUpvoted');
    bool _hasError = false;
    if (user == null) return false;
    DocumentReference upvoteDocRef = _getUpvoteDocumentRef(answer, user.id);
    DocumentSnapshot document = await upvoteDocRef.get().catchError((error) {
      print('$_tag error on getting document for checking user upvote');
      _hasError = true;
    });
    if (!_hasError || !document.exists) return false;
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
