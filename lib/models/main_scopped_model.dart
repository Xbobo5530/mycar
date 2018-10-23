import 'package:my_car/functions/functions.dart';
import 'package:my_car/functions/login_fun.dart';
import 'package:my_car/functions/status_code.dart';
import 'package:my_car/models/answer.dart';
import 'package:my_car/models/question.dart';
import 'package:my_car/models/user.dart';
import 'package:scoped_model/scoped_model.dart';

const tag = 'LoginModel';
final loginFun = LoginFunctions();
final userFun = User();
final fun = Functions();

abstract class LoginModel extends Model {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  StatusCode _loginStatus;

  StatusCode get loginStatus => _loginStatus;

  void getLoginStatus() {
    // get login status
    loginFun.isLoggedIn().then((isLoggedIn) {
      _isLoggedIn = isLoggedIn;
    });
    // Then notify all the listeners.
    notifyListeners();
  }

  void signInWithGoogle() async {
    _loginStatus = StatusCode.waiting;
    notifyListeners();
    _loginStatus = await loginFun.singInWithGoogle();
    notifyListeners();
  }
}

abstract class UserModel extends Model {
  User _currentUser;

  User get currentUser => _currentUser;

  User _userFromId;

  User get userFromId => _userFromId;

  bool _isCurrentUser = false;

  bool get isCurrentUser => _isCurrentUser;

  void getCurrentUser() async {
    if (await loginFun.isLoggedIn())
      userFun.getCurrentUser().then((user) {
        _currentUser = user;
        notifyListeners();
      });
  }

  void getUserFromId(String userId) async {
    _userFromId = await userFun.getUserFromUserId(userId);

    notifyListeners();
  }

  void checkIsCurrentUser(String userId) async {
    _isCurrentUser = await userFun.getCurrentUserId() == userId;
    notifyListeners();
  }
}

abstract class QuestionModel extends Model {
  bool _hasFollowed = false;

  bool get hasFollowed => _hasFollowed;

  void hasUserFollowed(Question question) async {
    if (await loginFun.isLoggedIn())
      _hasFollowed = await fun.userHasFollowed(question);
    else
      _hasFollowed = false;

    notifyListeners();
  }
}

abstract class AnswerModel extends Model {
  bool _hasUpvoted = false;

  bool get hasUpvoted => _hasUpvoted;

  void hasUserUpvoted(Answer answer) async {
    if (await loginFun.isLoggedIn())
      _hasUpvoted = await fun.userHasUpvoted(answer);
    else
      _hasUpvoted = false;
  }
}

class MyCarModel extends Model
    with LoginModel, UserModel, QuestionModel, AnswerModel {
  MyCarModel() {
    print('$tag at LoginModel()');
    getLoginStatus();
    getCurrentUser();
  }
}
