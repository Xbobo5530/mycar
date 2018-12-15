import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_car/src/models/user.dart';
import 'package:my_car/src/utils/consts.dart';
import 'package:my_car/src/utils/status_code.dart';
import 'package:scoped_model/scoped_model.dart';

const _tag = 'AccountModel:';

abstract class AccountModel extends Model {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _database = Firestore.instance;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  StatusCode _loggingOutStatus;
  StatusCode get loggingOutStatus => _loggingOutStatus;

  StatusCode _loginStatus;
  StatusCode get loginStatus => _loginStatus;

  User _currentUser;
  User get currentUser => _currentUser;

  StatusCode _updatingCurrentUserStatus;
  StatusCode get updatingCurrentUserStatus => _updatingCurrentUserStatus;

  Future<void> updateLoginStatus() async {
    print('$_tag at getLoginStatus');
    final user = await _auth.currentUser().catchError((error) {
      print('$_tag error on getting current user: $error');
      _isLoggedIn = false;
      _currentUser = null;
      notifyListeners();
    });

    _isLoggedIn = user != null;
    updateCurrentUser();
    notifyListeners();
    print('$_tag isLoggedIn is $_isLoggedIn');
  }

  Future<StatusCode> singInWithGoogle() async {
    print('$tag at singInWithGoogle');
    _loginStatus = StatusCode.waiting;
    notifyListeners();

    bool _hasError = false;
    final user = await _handleGoogleSignIn().catchError((error) {
      print('$tag error: $error');
      _hasError = true;
    });
    if (_hasError || user == null) {
      updateLoginStatus();
      return StatusCode.failed;
    }
    updateLoginStatus();
    _loginStatus = await _checkIfUserExists(user);
    notifyListeners();
    return _loginStatus;
  }

  Future<FirebaseUser> _handleGoogleSignIn() async {
    print('$tag at _handleGoogleSignIn');
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    print('$tag googleUser is : $googleUser');
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print('$tag signed in as ${user.displayName}');
    return user;
  }

  Future<StatusCode> _checkIfUserExists(FirebaseUser user) async {
    print('$tag at _checkIfUserExists');
    bool _hasError = false;

    final userId = user.uid;
    final userDoc = await _database
        .collection(COLLECTION_USERS)
        .document(userId)
        .get()
        .catchError((error) {
      print('$tag error on checking if user exists: $error');
      _hasError = true;
    });

    if (_hasError) return StatusCode.failed;
    if (userDoc.exists) return StatusCode.success;
    return await _createUserDoc(user);
  }

  Future<StatusCode> _createUserDoc(FirebaseUser user) async {
    print('$tag at _createUserDoc');
    bool _hasError = false;
    final username = user.displayName;
    final userId = user.uid;
    final userImageUrl = user.photoUrl;
    final createdAt = DateTime.now().millisecondsSinceEpoch;
    //create user doc map
    Map<String, dynamic> userDocMap = {
      FIELD_NAME: username,
      FIELD_ID: userId,
      FIELD_IMAGE_URL: userImageUrl,
      FIELD_CREATED_AT: createdAt,
    };
    await _database
        .collection(COLLECTION_USERS)
        .document(userId)
        .setData(userDocMap)
        .catchError((error) {
      print('$tag error on creating user doc: $error');
      _hasError = true;
    });
    if (_hasError) return StatusCode.failed;
    updateCurrentUser();
    return StatusCode.success;
  }

  Future<StatusCode> updateCurrentUser() async {
    print('$_tag at updateCurrentUser');
    _updatingCurrentUserStatus = StatusCode.waiting;
    notifyListeners();
    bool _hasError = false;
    if (!_isLoggedIn) {
      _currentUser = null;
      _updatingCurrentUserStatus = StatusCode.success;
      notifyListeners();
      return _updatingCurrentUserStatus;
    }
    final user = await _auth.currentUser().catchError((error) {
      print('$_tag error on getting current user: $error');
      _hasError = true;
    });
    if (_hasError) {
      _currentUser = null;
      _updatingCurrentUserStatus = StatusCode.failed;
      notifyListeners();
      return _updatingCurrentUserStatus;
    }
    if (user == null) {
      _currentUser = null;
      _updatingCurrentUserStatus = StatusCode.success;
      notifyListeners();
      return _updatingCurrentUserStatus;
    }
    final userId = user.uid;
    final DocumentSnapshot document = await _database
        .collection(COLLECTION_USERS)
        .document(userId)
        .get()
        .catchError((error) {
      print('$_tag error on getting user dcoument for current user: $error');
      _hasError = true;
    });

    if (_hasError || !document.exists) {
      _currentUser = null;
      _updatingCurrentUserStatus = StatusCode.failed;
      notifyListeners();
      return _updatingCurrentUserStatus;
    }
    _currentUser = User.fromSnapshot(document);
    _updatingCurrentUserStatus = StatusCode.success;
    notifyListeners();
    return _updatingCurrentUserStatus;
  }

  Future<StatusCode> logout() async {
    print('$_tag at logout');
    _loggingOutStatus = StatusCode.waiting;
    notifyListeners();
    bool _hasError = false;
    _auth.signOut().catchError((error) {
      print('$_tag error on signing out');
      _hasError = true;
      _loggingOutStatus = StatusCode.failed;
      notifyListeners();
    });
    if (_hasError) return _loggingOutStatus;
    updateLoginStatus();
    _loggingOutStatus = StatusCode.success;
    return _loggingOutStatus;
  }
}
