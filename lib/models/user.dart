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
        this.name = document[FIELD_NAME],
        this.bio = document[FIELD_BIO],
        this.createdAt = document[FIELD_CREATED_AT],
        this.imageUrl = document[FIELD_IMAGE_URL];
}
