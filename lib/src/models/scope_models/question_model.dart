import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_car/src/models/question.dart';
import 'package:my_car/src/models/user.dart';
import 'package:my_car/src/utils/cached_users.dart';
import 'package:my_car/src/utils/consts.dart';
import 'package:my_car/src/utils/status_code.dart';
import 'package:scoped_model/scoped_model.dart';

const _tag = 'QuestionModel:';

abstract class QuestionModel extends Model {
  final Firestore _database = Firestore.instance;
  List<Question> _questions;
  List<Question> get questions => _questions;
  StatusCode _submittingQuestionStatus;
  StatusCode get submittingQuestionStatus => _submittingQuestionStatus;
  StatusCode _deletingQuestonStatus;
  StatusCode get deletingQurstonStatus => _deletingQuestonStatus;
  StatusCode _handlingFollowQuestionStatus;
  StatusCode get handlingFollowQuestionStatus => _handlingFollowQuestionStatus;
  Stream<QuerySnapshot> questionsStream() => _database
      .collection(COLLECTION_QUESTIONS)
      .orderBy(FIELD_CREATED_AT, descending: true)
      .snapshots();

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

  Stream<QuerySnapshot> userQuestionsStream(User user) => _database
      .collection(COLLECTION_USERS)
      .document(user.id)
      .collection(COLLECTION_QUESTIONS)
      .snapshots();

  Future<StatusCode> submitQuestion(Question question) async {
    print('$_tag at submitQuestion');
    _submittingQuestionStatus = StatusCode.waiting;
    notifyListeners();
    bool _hasError = false;
    Map<String, dynamic> questionMap = {
      FIELD_CREATED_BY: question.createdBy,
      FIELD_QUESTION: question.question,
      FIELD_CREATED_AT: question.createdAt
    };
    DocumentReference ref = await _database
        .collection(COLLECTION_QUESTIONS)
        .add(questionMap)
        .catchError((error) {
      print('$_tag error on submitting question $error');
      _hasError = true;
    });

    if (_hasError) {
      _submittingQuestionStatus = StatusCode.failed;
      return _submittingQuestionStatus;
    }
    question.id = ref.documentID;
    _submittingQuestionStatus = await _createUserRef(question);

    return _submittingQuestionStatus;
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
    return true;
  }

  Future<StatusCode> _createUserRef(Question question) async {
    bool _hasError = false;
    Map<String, dynamic> userRefMap = {
      FIELD_ID: question.id,
      FIELD_CREATED_AT: question.createdAt,
      FIELD_CREATED_BY: question.createdBy
    };
    await _database
        .collection(COLLECTION_USERS)
        .document(question.createdBy)
        .collection(COLLECTION_QUESTIONS)
        .document(question.id)
        .setData(userRefMap)
        .catchError((error) {
      print('$_tag error on creating user ref');
      _hasError = true;
    });
    if (_hasError) return StatusCode.failed;
    return StatusCode.success;
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

  Future<User> _userFromId(String id) async {
    if (cachedUsers.containsKey(id)) return cachedUsers[id];
    bool _hasError = false;
    DocumentSnapshot document = await _database
        .collection(COLLECTION_USERS)
        .document(id)
        .get()
        .catchError((error) {
      print('$_tag error on getting user');
      _hasError = true;
    });
    if (_hasError || !document.exists) return null;
    User user = User.fromSnapshot(document);
    cachedUsers.putIfAbsent(id, () => user);
    return user;
  }

  Future<Question> refineQuestion(Question question) async {
    final user = await _userFromId(question.createdBy);
    question.username = user.name;
    if (user.imageUrl != null) question.userImageUrl = user.imageUrl;
    return question;
  }

  Future<StatusCode> deleteQuestion(Question question) async {
    _deletingQuestonStatus = StatusCode.waiting;
    notifyListeners();
    bool _hasError = false;
    await _database
        .collection(COLLECTION_QUESTIONS)
        .document(question.id)
        .delete()
        .catchError((error) {
      print('$_tag error on deleting question');
      _hasError = true;
      _deletingQuestonStatus = StatusCode.failed;
      notifyListeners();
    });
    if (_hasError) return _deletingQuestonStatus;
    return await _deleteUserRef(question);
  }

  Future<StatusCode> _deleteUserRef(Question question) async {
    bool _hasError = false;
    await _database
        .collection(COLLECTION_USERS)
        .document(question.createdBy)
        .collection(COLLECTION_QUESTIONS)
        .document(question.id)
        .delete()
        .catchError((error) {
      print('$_tag error on deleting user referernce for question');
      _hasError = true;
    });
    if (_hasError) return StatusCode.failed;
    return StatusCode.success;
  }
}
