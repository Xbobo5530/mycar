import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_car/models/user.dart';
import 'package:my_car/utils/consts.dart';
import 'package:scoped_model/scoped_model.dart';

abstract class UserModel extends Model {
  User _userFromId;

  User get userFromId => _userFromId;

  final _database = Firestore.instance;

  Future<User> getUserFromUserId(String userId) async {
    var _hasError = false;
    var userDocument = await _database
        .collection(USERS_COLLECTION)
        .document(userId)
        .get()
        .catchError((error) {
      print('$tag error on getting user from userId: $error');
      _hasError = true;
    });
    if (!userDocument.exists || _hasError)
      return null;
    else
      return User.fromSnapshot(userDocument);
  }
}
