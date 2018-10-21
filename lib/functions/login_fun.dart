import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_car/functions/functions.dart';
import 'package:my_car/values/strings.dart';

const tag = 'LoginFunctions';

final functions = Functions();

class LoginFunctions {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<FirebaseUser> _handleGoogleSignIn() async {
    print('$tag at _handleGoogleSignIn');
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    print('$tag signed in as ${user.displayName}');
    return user;
  }

  Future<bool> _createUserDoc(FirebaseUser user) async {
    print('$tag at _createUserDoc');
    var _hasError = false;
    var username = user.displayName;
    var userId = user.uid;
    var userImageUrl = user.photoUrl;
    var createdAt = DateTime.now().millisecondsSinceEpoch;
    //create user doc map
    Map<String, dynamic> userDocMap = {
      'name': username,
      'id': userId,
      'image_url': userImageUrl,
      'created_at': createdAt,
    };
    await functions.database
        .collection(USERS_COLLECTION)
        .document(userId)
        .setData(userDocMap)
        .catchError((error) {
      print('$tag error on creating user doc: $error');
      _hasError = true;
    });
    if (_hasError)
      return false;
    else
      return true;
  }

  Future<bool> _checkIfUserExists(FirebaseUser user) async {
    print('$tag at _checkIfUserExists');

    var userId = user.uid;
    var userDoc = await functions.database
        .collection(USERS_COLLECTION)
        .document(userId)
        .get()
        .catchError((error) {
      print('$tag error on checking if user exists: $error');
    });

    if (userDoc.exists) {
      return true;
    } else {
      return await _createUserDoc(user);
    }
  }

  Future<bool> singInWithGoogle() async {
    print('$tag at singInWithGoogle');
    var user = await _handleGoogleSignIn()
        .catchError((error) => print('$tag error: $error'));
    if (user != null)
      return await _checkIfUserExists(user);
    else
      return false;
  }

  logout() {
    auth.signOut();
    print('$tag user signed out');
  }

  Future<bool> isLoggedIn() async {
    var user = await auth.currentUser();
    return user != null;
  }
}
