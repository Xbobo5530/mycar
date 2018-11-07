import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_car/models/user.dart';
import 'package:my_car/utils/consts.dart';
import 'package:my_car/utils/status_code.dart';
import 'package:scoped_model/scoped_model.dart';

const _tag = 'AccountModel:';

abstract class AccountModel extends Model {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _database = Firestore.instance;

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  StatusCode _loginStatus;

  StatusCode get loginStatus => _loginStatus;

  User _currentUser;

  User get currentUser => _currentUser;

  StatusCode _updatingCurrentUserStatus;

  StatusCode get updatingCurrentUserStatus => _updatingCurrentUserStatus;

  Future<void> updateLoginStatus() async {
    print('$_tag at getLoginStatus');
    bool _hasError = false;
    final user = _auth.currentUser().catchError((error) {
      print('$_tag error on getting current user: $error');
      _hasError = false;
    });
    if (user == null || _hasError) {
      _currentUser = null;
      _isLoggedIn = false;
      notifyListeners();
      return;
    }
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<StatusCode> singInWithGoogle() async {
    print('$tag at singInWithGoogle');
    _loginStatus = StatusCode.waiting;
    notifyListeners();

    bool _hasError = false;
    var user = await _handleGoogleSignIn().catchError((error) {
      print('$tag error: $error');
      _hasError = true;
    });
    if (_hasError || user == null) {
      updateCurrentUser();
      return StatusCode.failed;
    }

    return await _checkIfUserExists(user);
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

    var userId = user.uid;
    var userDoc = await functions.database
        .collection(USERS_COLLECTION)
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
      NAME_FIELD: username,
      ID_FIELD: userId,
      IMAGE_URL_FIELD: userImageUrl,
      CREATED_AT_FIELD: createdAt,
    };
    await functions.database
        .collection(USERS_COLLECTION)
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
      notifyListeners();
      return StatusCode.success;
    }
    final user = await _auth.currentUser().catchError((error) {
      print('$_tag error on getting current user: $error');
      _hasError = true;
    });
    if (user == null || _hasError) {
      _currentUser = null;
      notifyListeners();
      return StatusCode.failed;
    }
    final userId = user.uid;
    final DocumentSnapshot document = await _database
        .collection(USERS_COLLECTION)
        .document(userId)
        .get()
        .catchError((error) {
      print('$_tag error on getting user dcoument for current user: $error');
      _hasError = true;
    });

    if (!document.exists || _hasError) {
      _currentUser = null;
      notifyListeners();
      return StatusCode.failed;
    }
    _currentUser = User.fromSnapshot(document);
    notifyListeners();
    return StatusCode.success;
  }
}
