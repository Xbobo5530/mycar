import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_car/functions/functions.dart';
import 'package:my_car/functions/login_fun.dart';
import 'package:my_car/models/account_model.dart';
import 'package:my_car/models/answer.dart';
import 'package:my_car/models/question.dart';
import 'package:my_car/models/question_model.dart';
import 'package:my_car/models/user.dart';
import 'package:my_car/models/user_model.dart';
import 'package:my_car/utils/consts.dart';
import 'package:my_car/utils/status_code.dart';
import 'package:scoped_model/scoped_model.dart';

const _tag = 'MyCarModel';
final loginFun = LoginFunctions();
final userFun = User();
final fun = Functions();

abstract class AnswerModel extends Model {
  bool _hasUpvoted = false;

  bool get hasUpvoted => _hasUpvoted;
}

class MainModel extends Model
    with AccountModel, UserModel, QuestionModel, AnswerModel, NavModel {
  MainModel() {
    print('$_tag at MainModel()');
    updateLoginStatus();
  }
}
