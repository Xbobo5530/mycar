import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_car/models/answer.dart';
import 'package:my_car/models/question.dart';
import 'package:my_car/models/user.dart';
import 'package:my_car/utils/consts.dart';
import 'package:my_car/utils/status_code.dart';
import 'package:scoped_model/scoped_model.dart';

const _tag = 'AnswerModel:';

abstract class AnswerModel extends Model{
  final _database = Firestore.instance;

  StatusCode _submittingAnswerStatus;
  StatusCode get submittingAnswerStatus => _submittingAnswerStatus;

  StatusCode _handlingUpvoteAnswerStatus;
  StatusCode get handlingUpvoteAnswerStatus => _handlingUpvoteAnswerStatus;

  Stream<QuerySnapshot> answersStreamFor(Question question) {
    return _database
        .collection(COLLECTION_QUESTIONS)
        .document(question.id)
        .collection(COLLECTION_ANSWERS)
        .orderBy(FIELD_VOTES, descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> upvotesStreamFor(Answer answer) {
    return _database
        .collection(COLLECTION_QUESTIONS)
        .document(answer.questionId)
        .collection(COLLECTION_ANSWERS)
        .document(answer.id)
        .collection(COLLECTION_UPVOTES)
        .snapshots();
  }

  Future<StatusCode> submitAnswer(Answer answer) async {
    print('$_tag at submitAnswer');
    _submittingAnswerStatus = StatusCode.waiting;
    notifyListeners();
    bool _hasError = false;

    Map<String, dynamic> answerMap = {
      FIELD_CREATED_BY: answer.createdBy,
      FIELD_ANSWER: answer.answer,
      FIELD_VOTES: answer.votes,
      FIELD_QUESTION_ID: answer.questionId,
      FIELD_CREATED_AT: answer.createdAt
    };

    await _database
        .collection(COLLECTION_QUESTIONS)
        .document(answer.questionId)
        .collection(COLLECTION_ANSWERS)
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
        FIELD_CREATED_BY: userId,
        FIELD_ANSWER_ID: answer.id,
        FIELD_QUESTION_ID: answer.questionId,
        FIELD_CREATED_AT: DateTime.now().millisecondsSinceEpoch
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
    return await _updateUpvotesCount(answer);
  }

  Future<StatusCode> _updateUpvotesCount(answer) async {
    print('$_tag at _updateVotesCount');
    bool _hasError = false;
    int newVoteCount = await _getUpvoteCount(answer);
    await _getAnswerDocumentRefFor(answer)
        .updateData({FIELD_VOTES: newVoteCount}).catchError((error) {
      print('$_tag error on updating votes count');
      _hasError = true;
    });
    if (_hasError) return StatusCode.failed;
    return StatusCode.success;
  }

  DocumentReference _getAnswerDocumentRefFor(Answer answer) {
    return _database
        .collection(COLLECTION_QUESTIONS)
        .document(answer.questionId)
        .collection(COLLECTION_ANSWERS)
        .document(answer.id);
  }

  CollectionReference _getUpvoteCollectionRefFor(Answer answer) {
    return _database
        .collection(COLLECTION_QUESTIONS)
        .document(answer.questionId)
        .collection(COLLECTION_ANSWERS)
        .document(answer.id)
        .collection(COLLECTION_UPVOTES);
  }

  Future<int> _getUpvoteCount(Answer answer) async {
    print('$_tag at _getUpvoteCount');
    bool _hasError = false;
    QuerySnapshot upvoteSnapshot = await _getUpvoteCollectionRefFor(answer)
        .getDocuments()
        .catchError((error) {
      print('$_tag error on getting documents to count upvotes: $error');
      _hasError = true;
    });

    if (_hasError) return 0;

    return upvoteSnapshot.documents.length;
  }

  Future<bool> userHasUpvoted(Answer answer, User user) async {
    print('$_tag at userHasUpvoted');
    bool _hasError = false;
    if (user == null) return false;
    DocumentReference upvoteDocRef = _getUpvoteDocumentRef(answer, user.id);
    DocumentSnapshot document = await upvoteDocRef.get().catchError((error) {
      print('$_tag error on getting document for checking user upvote');
      _hasError = true;
    });
    if (_hasError || !document.exists) return false;
    return true;
  }

  DocumentReference _getUpvoteDocumentRef(Answer answer, String userId) {
    return _database
        .collection(COLLECTION_QUESTIONS)
        .document(answer.questionId)
        .collection(COLLECTION_ANSWERS)
        .document(answer.id)
        .collection(COLLECTION_UPVOTES)
        .document(userId);
  }
}
