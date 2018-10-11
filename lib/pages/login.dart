import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_car/functions/functions.dart';
import 'package:my_car/pages/home.dart';
import 'package:my_car/values/strings.dart';
import 'package:google_sign_in/google_sign_in.dart';

const tag = 'LoginPage:';
final functions = Functions();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(loginText),
      ),
      body: Center(
        child: RaisedButton(
            child: Text(signInWithGoogleText),
            onPressed: () => _singInWithGoogle()),
      ),
    );
  }

  _singInWithGoogle() {
    _handleGoogleSignIn().then((user) {
      print('$tag user is $user');
      _checkIfUserExists(user);
    }).catchError((error) => print('$tag error: $error'));
  }

  Future<FirebaseUser> _handleGoogleSignIn() async {
    print('$tag at _handleGoogleSignIn');
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    print('$tag signed in as ${user.displayName}');
    return user;
  }

  void _createUserDoc(BuildContext context, FirebaseUser user) {
    print('$tag at _createUserDoc');
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
    functions.database
        .collection(USERS_COLLECTION)
        .document(userId)
        .setData(userDocMap)
        .catchError((error) {
      print(error);
    }).whenComplete(() {
      _goToHomePage(context);
    });
  }

  void _checkIfUserExists(FirebaseUser user) {
    print('$tag at _checkIfUserExists');
    var userId = user.uid;
    functions.database
        .collection(USERS_COLLECTION)
        .document(userId)
        .get()
        .then((document) {
      document.exists ? _goToHomePage(context) : _createUserDoc(context, user);
    });
  }

  _goToHomePage(BuildContext context) {
    print('$tag at _goToHomePage');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }
}
