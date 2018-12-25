import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_car/src/models/user.dart';
import 'package:my_car/src/utils/consts.dart';
import 'package:scoped_model/scoped_model.dart';

abstract class UserModel extends Model {
  Map<String, User> _cachedUsers = Map();

  final _database = Firestore.instance;

  Future<User> getUserFromUserId(String userId) async {
    if (_cachedUsers.containsKey(userId)) return _cachedUsers[userId];
    bool _hasError = false;
    final userDocument = await _database
        .collection(COLLECTION_USERS)
        .document(userId)
        .get()
        .catchError((error) {
      print('$tag error on getting user from userId: $error');
      _hasError = true;
    });
    if (!userDocument.exists || _hasError) return null;
    final userFromId = User.fromSnapshot(userDocument);
    _cachedUsers.putIfAbsent(userId, () => userFromId);
    return userFromId;
  }
}
