import 'package:my_car/utils/consts.dart';

const tag = 'User';

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
