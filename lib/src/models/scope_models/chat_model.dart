import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_car/src/models/chat.dart';
import 'package:my_car/src/models/user.dart';
import 'package:my_car/src/utils/consts.dart';
import 'package:my_car/src/utils/status_code.dart';
import 'package:scoped_model/scoped_model.dart';

abstract class ChatModel extends Model {
  final Firestore _database = Firestore.instance;
  Stream<QuerySnapshot> liveChatStream() => _database
      .collection(COLLECTIONS_CHATS)
      .orderBy(FIELD_CREATED_AT, descending: true)
      .snapshots();

  Future<StatusCode> sendMessage(String message, User user) async {
    Chat chat = _makeChat(message, user);
    bool _hasError = false;
    Map<String, dynamic> chatMap = {
      FIELD_MESSAGE: message,
      FIELD_CREATED_AT: chat.createdAt,
      FIELD_FILE_TYPE: chat.fileType,
      FIELD_CREATED_BY: chat.createdBy
    };
    await _database
        .collection(COLLECTIONS_CHATS)
        .add(chatMap)
        .catchError((error) {
      print('Error on sending message');
      _hasError = true;
    });
    if (_hasError) return StatusCode.failed;
    return StatusCode.success;
  }

  Chat _makeChat(String message, User user) => Chat(
      message: message,
      createdBy: user.id,
      createdAt: DateTime.now().millisecondsSinceEpoch);

  Future<Chat> refinedChat(Chat chat) async {
    User user = await _userFromId(chat.createdBy);
    if (user == null) return null;
    chat.username = user.name;
    chat.userImageUrl = user.imageUrl;
    return chat;
  }

  Future<User> _userFromId(String id) async {
    bool _hasError = false;
    DocumentSnapshot document = await _database
        .collection(COLLECTION_USERS)
        .document(id)
        .get()
        .catchError((error) {
      print('error on getting user from id');
      _hasError = true;
    });
    if (_hasError || !document.exists) return null;
    return User.fromSnapshot(document);
  }

  String chatMetaData(Chat chat) {
    final DateTime time = DateTime.fromMillisecondsSinceEpoch(chat.createdAt);
    return '${time.hour}:${time.minute}';
  }
}
