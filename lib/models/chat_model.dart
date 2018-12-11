import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_car/utils/consts.dart';
import 'package:scoped_model/scoped_model.dart';

abstract class ChatModel extends Model{
  final Firestore _database = Firestore.instance;
  Stream<QuerySnapshot> liveChatStream() => _database.collection(COLLECTIONS_CHATS)
  .snapshots();
}