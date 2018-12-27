import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_car/src/models/ad.dart';
import 'package:my_car/src/models/user.dart';
import 'package:my_car/src/utils/cached_users.dart';
import 'package:my_car/src/utils/consts.dart';
import 'package:my_car/src/utils/status_code.dart';
import 'package:scoped_model/scoped_model.dart';

const _tag = 'AdModel:';

abstract class AdModel extends Model {
  Firestore _database = Firestore.instance;
  StatusCode _submittingAdStatus;
  StatusCode get submittingAdStatus => _submittingAdStatus;
  Ad _latestAd;
  List<Ad> _ads = [];
  List<Ad> get ads => _ads;
  Map<String, User> _cachedUsers = Map();
  Ad get latestAd => _latestAd;
  Stream<QuerySnapshot> adStream() => _database
      .collection(COLLECTION_ADS)
      .orderBy(FIELD_CREATED_AT, descending: true)
      .snapshots();

  /// submits an Ad to the database
  /// takes an [Ad] object [ad]
  /// returns a [Map<String, dynamic>]
  /// the [Map] returned contains the [STATUS_CODE] of type [StatusCode]
  /// and a [FIELD_ID] which is the id of the ad tha was added to the nelwy created ad
  /// the [FIELD_ID] is null when the [STATUS_CODE] has is [StatusCode.failed]
  Future<Map<String, dynamic>> submitAd(Ad ad) async {
    _submittingAdStatus = StatusCode.waiting;
    bool _hasError = false;
    Map<String, dynamic> adMap = {
      FIELD_DESCRIPTION: ad.description,
      FIELD_CREATED_BY: ad.createdBy,
      FIELD_CREATED_AT: ad.createdAt,
      FIELD_CONTACT: ad.contact,
      FIELD_FILE_STATUS: ad.imageStatus
    };

    DocumentReference ref = await _database
        .collection(COLLECTION_ADS)
        .add(adMap)
        .catchError((errpr) {
      print('$_tag error on creating ad map');
      _hasError = true;
      _submittingAdStatus = StatusCode.failed;
      notifyListeners();
    });
    if (_hasError) return {STATUS_CODE: _submittingAdStatus};
    _submittingAdStatus = StatusCode.success;
    _createUserAdRef(ad,ref);
    return {STATUS_CODE: _submittingAdStatus, FIELD_ID: ref.documentID};
  }

  Future<User> _userFromId(String id) async {
    if (cachedUsers.containsKey(id)) return cachedUsers[id];
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
    final User user = User.fromSnapshot(doc);
    cachedUsers.putIfAbsent(id, () => user);
    return user;
  }

  Future<void> _createUserAdRef(Ad ad, DocumentReference ref) async {
    // bool _hasError = false;
    Map<String, dynamic> adRefMap = {
      FIELD_ID: ref.documentID,
      FIELD_CREATED_AT: ad.createdAt,
      FIELD_CREATED_BY: ad.createdBy,

    };
    await _database
        .collection(COLLECTION_USERS)
        .document(ad.createdBy)
        .collection(COLLECTION_ADS)
        .document(ref.documentID)
        .setData(adRefMap)
        .catchError((error) {
      print('$_tag error on creating a user red');
      // _hasError = false;
    });
  }

  Future<Ad> refineAd(Ad ad) async {
    User user = await _userFromId(ad.createdBy);
    ad.username = user.name;
    ad.userImageUrl = user.imageUrl;
    return ad;
  }

  Future<void> getAds() async {
    bool _hasError = false;
    List<Ad> tempList = [];
    QuerySnapshot snapshot = await _database
        .collection(COLLECTION_ADS)
        .getDocuments()
        .catchError((error) {
      print('$_tag error on getting ads');
      _hasError = false;
    });
    if (_hasError) return null;
    snapshot.documents.forEach((document) {
      tempList.add(Ad.fromSnapshot(document));
    });
    _ads = tempList;
  }
}
