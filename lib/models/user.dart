import 'dart:async';

import 'package:my_car/functions/functions.dart';
import 'package:my_car/functions/login_fun.dart';
import 'package:my_car/utils/consts.dart';
import 'package:my_car/utils/strings.dart';

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
}
