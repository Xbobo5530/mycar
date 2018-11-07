import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_car/models/account_model.dart';
import 'package:my_car/models/question.dart';
import 'package:my_car/utils/consts.dart';
import 'package:my_car/utils/status_code.dart';
import 'package:scoped_model/scoped_model.dart';

const _tag = 'QuestionModel:';

abstract class QuestionModel extends Model with AccountModel {
  final Firestore _database = Firestore.instance;

  StatusCode _submittingQuestionStatus;
  StatusCode get submittingQuestionStatus => _submittingQuestionStatus;

  StatusCode _handlingFollowQuestionStatus;

  StatusCode get handlingFollowQuestionStatus => _handlingFollowQuestionStatus;

  Future<StatusCode> submitQuestion(
      String question, String currentUserId) async {
    print('$_tag at submitQuestion');
    _submittingQuestionStatus = StatusCode.waiting;
    notifyListeners();
    var _hasError = false;

    /// create question map
    Map<String, dynamic> questionMap = {
      CREATED_BY_FIELD: currentUserId,
      QUESTION_FIELD: question,
      CREATED_AT_FIELD: DateTime.now().millisecondsSinceEpoch
    };

    /// add question to database
    await _database
        .collection(QUESTIONS_COLLECTION)
        .add(questionMap)
        .catchError((error) {
      print('$_tag error on submitting question $error');
      _hasError = true;
    });

    if (_hasError) return StatusCode.failed;
    return StatusCode.success;
  }

  Future<bool> isUserFollowing(Question question, String userId) async {
    print('$_tag at isUserFollowing');
    bool _hasError = false;

    if (!isLoggedIn) return false;
    DocumentReference followDocRef = _getFollowingDocumentRef(question, userId);
    DocumentSnapshot document = await followDocRef.get().catchError((error) {
      print('$_tag error on getting document for checking following status');
      _hasError = true;
    });
    if (!document.exists || _hasError) return false;

    return true;
  }

  DocumentReference _getFollowingDocumentRef(Question question, String userId) {
    return _database
        .collection(QUESTIONS_COLLECTION)
        .document(question.id)
        .collection(FOLLOWERS_COLLECTION)
        .document(userId);
  }

  /// handle follow question
  /// if the user has already followed the [question], un-follow it
  /// if the user has not followed the [question], follow it
  /// [userId] is the Id of the user (usually current user)
  /// returns a [Future] of a [StatusCode] for the status of the follow

  Future<StatusCode> handleFollowQuestion(
      Question question, String userId) async {
    print('$tag at followQuestion');
    _handlingFollowQuestionStatus = StatusCode.waiting;
    notifyListeners();
    bool _hasError = false;

    DocumentReference followerDocRef =
        _getFollowingDocumentRef(question, userId);

    DocumentSnapshot document = await followerDocRef.get().catchError(((error) {
      print('$tag error on following question: $error');
      _hasError = true;
    }));
    if (_hasError) return StatusCode.failed;

    if (document.exists)
      followerDocRef.delete().catchError((error) {
        print('$tag error on deleting followed question doc: $error');
        _hasError = true;
      });
    else {
      Map<String, dynamic> followMap = {
        USER_ID_FIELD: userId,
        ANSWER_ID_FIELD: question.id,
        CREATED_AT_FIELD: DateTime.now().millisecondsSinceEpoch
      };
      followerDocRef.setData(followMap).catchError((error) {
        print('$tag error on adding follow: $error');
        _hasError = true;
        _handlingFollowQuestionStatus = StatusCode.failed;
        notifyListeners();
      });
    }

    if (_hasError) return StatusCode.failed;
    _handlingFollowQuestionStatus = StatusCode.success;
    notifyListeners();
    return _handlingFollowQuestionStatus;
  }
}
