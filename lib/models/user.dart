import 'dart:async';

import 'package:my_car/functions/functions.dart';
import 'package:my_car/functions/login_fun.dart';
import 'package:my_car/values/strings.dart';

const tag = 'User';

final functions = Functions();
final loginFun = LoginFunctions();

class User {
  String id, name, imageUrl, bio;
  int createdAt;

  User({this.name, this.bio, this.imageUrl, this.createdAt});

  User.fromSnapshot(var value) {
    this.name = value[NAME_FIELD];
    this.bio = value[BIO_FIELD];
    this.createdAt = value[CREATED_AT_FIELD];
    this.imageUrl = value[IMAGE_URL_FIELD];
  }

  Future<User> getUserFromUserId(String userId) async {
    var _hasError = false;
    var userDocument = await functions.database
        .collection(USERS_COLLECTION)
        .document(userId)
        .get()
        .catchError((error) {
      print('$tag error on getting user from userId: $error');
      _hasError = true;
    });
    if (userDocument.exists && !_hasError)
      return User.fromSnapshot(userDocument);
    else
      return null;
  }

  Future<User> getCurrentUser() async {
    var _hasError = false;
    var userId = await getCurrentUserId();
    var userDoc = await functions.database
        .collection(USERS_COLLECTION)
        .document(userId)
        .get()
        .catchError((error) {
      print('$tag error on converting user: $error');
      _hasError = true;
    });
    if (userDoc.exists && !_hasError)
      return User.fromSnapshot(userDoc);
    else
      return null;
  }

  Future<String> getCurrentUserId() async {
    if (await loginFun.isLoggedIn()) {
      var user = await loginFun.auth.currentUser();
      return user.uid;
    } else {
      return null;
    }
  }
}
