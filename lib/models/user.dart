import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_car/utils/consts.dart';

const tag = 'User';

/// the app user
class User {
  String id, 
  /// the name of the user
  name, 
  ///the image Url of the user if given
  imageUrl, 
  /// the user bio if given
  bio;
  /// when the user was first created
  int createdAt;

  User({this.name, this.bio, this.imageUrl, this.createdAt});
  /// a constructor for a user extracted from
  /// a [DocumentSnapshot] [document]
  User.fromSnapshot(DocumentSnapshot document)
      : this.id = document.documentID,
        this.name = document[NAME_FIELD],
        this.bio = document[BIO_FIELD],
        this.createdAt = document[CREATED_AT_FIELD],
        this.imageUrl = document[IMAGE_URL_FIELD];
}
