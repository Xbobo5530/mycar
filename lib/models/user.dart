import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_car/utils/consts.dart';

const tag = 'User';

class User {
  String id, name, imageUrl, bio;
  int createdAt;

  User({this.name, this.bio, this.imageUrl, this.createdAt});

  User.fromSnapshot(DocumentSnapshot document)
      : this.id = document.documentID,
        this.name = document[NAME_FIELD],
        this.bio = document[BIO_FIELD],
        this.createdAt = document[CREATED_AT_FIELD],
        this.imageUrl = document[IMAGE_URL_FIELD];
}
