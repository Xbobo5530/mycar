//import 'dart:async';
//import 'dart:collection';
//import 'package:my_car/values/strings.dart';
//import 'package:rxdart/rxdart.dart';
//import 'package:my_car/models/user.dart';
//
//class UsersBloc {
//  HashMap<String, User> _cachedUsers;
//
//  var _usersFromId = <User>[];
//
//  final _user = BehaviorSubject<User>();
//
//  final _userStream = StreamController<String>();
//
//  UsersBloc() {
//    _cachedUsers = HashMap<String, User>();
//    _userStream.stream.listen((userId) async {
//      _getUserFromId(userId);
//    });
//  }
//
//  Sink<String> get userFromId => _userStream.sink;
//
//  void close() {
//    _userStream.close();
//  }
//
//  Future<User> _getUserFromId(String userId) async {
//    var _hasError = false;
//    var userDocument = await functions.database
//        .collection(USERS_COLLECTION)
//        .document(userId)
//        .get()
//        .catchError((error) {
//      print('$tag error on getting user from userId: $error');
//      _hasError = true;
//    });
//    if (userDocument.exists && !_hasError)
//      _cachedUsers[userId] = User.fromSnapshot(userDocument);
//      return ;
//    else
//      return null;
//  }
//}
