import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_car/models/chat.dart';
import 'package:my_car/models/user.dart';
import 'package:my_car/utils/consts.dart';
import 'package:my_car/utils/status_code.dart';
import 'package:scoped_model/scoped_model.dart';

abstract class ChatModel extends Model {
  final Firestore _database = Firestore.instance;
  Stream<QuerySnapshot> liveChatStream() =>
      _database.collection(COLLECTIONS_CHATS).snapshots();

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
}
