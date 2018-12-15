import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_car/src/models/question.dart';
import 'package:my_car/src/models/user.dart';
import 'package:my_car/src/utils/consts.dart';
import 'package:my_car/src/utils/status_code.dart';
import 'package:scoped_model/scoped_model.dart';

const _tag = 'QuestionModel:';

abstract class QuestionModel extends Model {
  final Firestore _database = Firestore.instance;
   List<Question> _questions;
    List<Question>  get questions => _questions;

  StatusCode _submittingQuestionStatus;
  StatusCode get submittingQuestionStatus => _submittingQuestionStatus;

  StatusCode _handlingFollowQuestionStatus;
  StatusCode get handlingFollowQuestionStatus => _handlingFollowQuestionStatus;

  Stream<QuerySnapshot> questionsStream() {
    return _database
        .collection(COLLECTION_QUESTIONS)
        .orderBy(FIELD_CREATED_AT, descending: true)
        .snapshots();
  }

  Future<List<Question>> getQuestions() async {
    QuerySnapshot snapshot =
        await _database.collection(COLLECTION_QUESTIONS).getDocuments();
    List documents = snapshot.documents;
    List<Question> questions = <Question>[];
    documents.forEach((document) {
      final question = Question.fromSnapshot(document);
      questions.add(question);
    });
    _questions = questions;
    notifyListeners();
    return questions;
  }

  Future<StatusCode> submitQuestion(
      String question, String currentUserId) async {
    print('$_tag at submitQuestion');
    _submittingQuestionStatus = StatusCode.waiting;
    notifyListeners();
    var _hasError = false;

    /// create question map
    Map<String, dynamic> questionMap = {
      FIELD_CREATED_BY: currentUserId,
      FIELD_QUESTION: question,
      FIELD_CREATED_AT: DateTime.now().millisecondsSinceEpoch
    };

    /// add question to database
    await _database
        .collection(COLLECTION_QUESTIONS)
        .add(questionMap)
        .catchError((error) {
      print('$_tag error on submitting question $error');
      _hasError = true;
    });

    if (_hasError) return StatusCode.failed;
    return StatusCode.success;
  }

  Future<bool> isUserFollowing(Question question, User user) async {
    // print('$_tag at isUserFollowing');
    bool _hasError = false;

    if (user == null) return false;
    DocumentReference followDocRef =
        _getFollowingDocumentRef(question, user.id);
    DocumentSnapshot document = await followDocRef.get().catchError((error) {
      print('$_tag error on getting document for checking following status');
      _hasError = true;
    });
    if (_hasError || !document.exists) return false;
//    print('$_tag ${user.name} is following ${question.question}');

    return true;
  }

  DocumentReference _getFollowingDocumentRef(Question question, String userId) {
    return _database
        .collection(COLLECTION_QUESTIONS)
        .document(question.id)
        .collection(COLLECTION_FOLLOWERS)
        .document(userId);
  }

  /// handle follow question
  /// if the user has already followed the [question], un-follow it
  /// if the user has not followed the [question], follow it
  /// [userId] is the Id of the user (usually current user)
  /// returns a [Future] of a [StatusCode] for the status of the follow

  Future<StatusCode> handleFollowQuestion(
      Question question, String userId) async {
    print('$tag at handleFollowQuestion');
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

    if (document.exists) {
      followerDocRef.delete().catchError((error) {
        print('$tag error on deleting followed question doc: $error');
        _hasError = true;
      });
      _handlingFollowQuestionStatus = StatusCode.success;
      notifyListeners();
      return _handlingFollowQuestionStatus;
    }

    Map<String, dynamic> followMap = {
      FIELD_USER_ID: userId,
      FIELD_ANSWER_ID: question.id,
      FIELD_CREATED_AT: DateTime.now().millisecondsSinceEpoch
    };
    followerDocRef.setData(followMap).catchError((error) {
      print('$tag error on adding follow: $error');
      _hasError = true;
      _handlingFollowQuestionStatus = StatusCode.failed;
      notifyListeners();
    });

    if (_hasError) return StatusCode.failed;
    _handlingFollowQuestionStatus = StatusCode.success;
    notifyListeners();
    return _handlingFollowQuestionStatus;
  }
}