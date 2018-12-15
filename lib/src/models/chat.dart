import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:my_car/src/utils/consts.dart';

class Chat {
  String id, message, fileUrl, filePath, 
  createdBy, 
  /// the [username] and the [userImageUrl] will be inected after they are 
  /// separately fetched from the [createdBy] data
  username, userImageUrl,
  
  /// the id of the message that [this] [Chat] is replying to
  replyingTo;
  /// when the chat has no file atttched to it, 
  /// it will have a [FILE_TYPE_NO_FILE] tag
  /// otherwise it this field will correspond to 
  /// a given file type [FILE_TYPE_IMAGE],
  /// [FILE_TYPE_VIDEO], [FILE_TYPE_AUDIO], of [FILE_TYPE_DOC]
  int fileType, createdAt;

  Chat(
      {this.id,
      this.message,
      this.fileUrl,
      this.filePath,
      @required this.createdBy,
      this.username,
      this.userImageUrl,
      this.replyingTo,
      this.fileType = FILE_TYPE_NO_FILE,
      @required this.createdAt});

  Chat.fromSnapshot(DocumentSnapshot doc)
      : this.id = doc.documentID,
        this.message = doc[FIELD_MESSAGE],
        this.fileUrl = doc[FIELD_FILE_URL],
        this.filePath = doc[FIELD_FILE_PATH],
        this.createdAt = doc[FIELD_CREATED_AT],
        this.createdBy = doc[FIELD_CREATED_BY],
        this.replyingTo = doc[FIELD_REPLYING_TO],
        this.fileType = doc[FIELD_FILE_TYPE];
}
