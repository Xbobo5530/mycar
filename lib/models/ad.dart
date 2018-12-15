import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_car/utils/consts.dart';

class Ad {
  String id,description ,createdBy, imageUrl, imagePath, username, userImageUrl;
  Map<String, String> contact;
  int createdAt;

  Ad(
      {this.id,
      this.description,
      this.createdAt,
      this.imagePath,
      this.imageUrl,
      this.contact,
      this.createdBy,
      this.username, this.userImageUrl
      
      });
  Ad.fromSnapshot(DocumentSnapshot doc)
      : id = doc.documentID,
        description = doc[FIELD_DESCRIPTION],
        createdBy = doc[FIELD_CREATED_BY],
        createdAt = doc[FIELD_CREATED_AT],
        imageUrl = doc[FIELD_IMAGE_URL],
        imagePath = doc[FIELD_IMAGE_PATH],
        contact = doc[FIELD_CONTACT];
}
