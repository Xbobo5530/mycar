import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_car/src/models/ad.dart';
import 'package:my_car/src/models/user.dart';
import 'package:my_car/src/utils/consts.dart';
import 'package:my_car/src/utils/status_code.dart';
import 'package:scoped_model/scoped_model.dart';

const _tag = 'AdModel:';

abstract class AdModel extends Model {
  Firestore _database = Firestore.instance;
  StatusCode _submittingAdStatus;
  StatusCode get submittingAdStatus => _submittingAdStatus;
  Ad _latestAd;
  Ad get latestAd => _latestAd;
  Stream<QuerySnapshot> adStream() =>
      _database.collection(COLLECTION_ADS).snapshots();

  Future<StatusCode> submitAd(Ad ad) async {
    bool _hasError = false;
    Map<String, dynamic> adMap = {
      FIELD_DESCRIPTION: ad.description,
      FIELD_CREATED_BY : ad.createdBy,
      FIELD_CREATED_AT : ad.createdAt,
      FIELD_CONTACT : ad.contact,
      FIELD_FILE_STATUS : ad.imageStatus
      
    };
  }

  Future<User> _userFromId(String id) async {
    bool _hasError = false;
    DocumentSnapshot doc = await _database
        .collection(COLLECTION_USERS)
        .document(id)
        .get()
        .catchError((error) {
      print('error on getting user from id: $error');
      _hasError = true;
    });
    if (_hasError || !doc.exists) return null;
    return User.fromSnapshot(doc);
  }

  Future<Ad> refineAd(Ad ad) async {
    User user = await _userFromId(ad.createdBy);
    ad.username = user.name;
    ad.userImageUrl = user.imageUrl;
    return ad;
  }
}
