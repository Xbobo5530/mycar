import 'package:my_car/functions/functions.dart';
import 'package:my_car/functions/login_fun.dart';
import 'package:my_car/models/question.dart';
import 'package:my_car/models/user.dart';
import 'package:scoped_model/scoped_model.dart';

const tag = 'LoginModel';
final loginFun = LoginFunctions();
final userFun = User();
final fun = Functions();

class MyCarModel extends Model {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  User _currentUser;

  User get currentUser => _currentUser;

  bool _hasFollowed = false;

  bool get hasFollowed => _hasFollowed;

  User _userFromId;

  User get userFromId => _userFromId;

//  MyCarModel() {
//    print('$tag at LoginModel()');
//    getLoginStatus();
//    getCurrentUser();
//  }

  void getLoginStatus() {
    // get login status
    loginFun.isLoggedIn().then((isLoggedIn) {
      _isLoggedIn = isLoggedIn;
    });
    // Then notify all the listeners.
    notifyListeners();
  }

  void getCurrentUser() async {
    if (await loginFun.isLoggedIn())
      userFun.getCurrentUser().then((user) {
        _currentUser = user;
        notifyListeners();
      });
  }

  void hasUserFollowed(Question question) async {
    if (await loginFun.isLoggedIn())
      _hasFollowed = await fun.userHasFollowed(question);
    else
      _hasFollowed = false;

    notifyListeners();
  }

  void getUserFromId(String userId) async {
    _userFromId = await userFun.getUserFromUserId(userId);

    notifyListeners();
  }
}
