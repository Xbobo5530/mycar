import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_car/src/utils/consts.dart';
import 'package:my_car/src/utils/status_code.dart';

import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

const _tag = 'ImageModel:';

abstract class FileModel extends Model {
  final FirebaseStorage _storage = FirebaseStorage();
  final Firestore _database = Firestore.instance;
  File _imageFile;
  File get imageFile => _imageFile;
  StatusCode _uploadStatus;
  StatusCode get uploadStatus => _uploadStatus;
  String _fileUrl;
  String get fileUrl => _fileUrl;
  String _filePath;
  String get filePath => _filePath;
  List<StorageUploadTask> _tasks = <StorageUploadTask>[];

  Future<StatusCode> getFile(AddFileItem item) async {
    print('$_tag at getFile');
    bool _hasError = false;
    switch (item) {
      case AddFileItem.camera:
        _imageFile = await ImagePicker.pickImage(source: ImageSource.camera)
            .catchError((error) {
          print('$_tag error on picking image from camera');
          _hasError = true;
        });
        notifyListeners();
        break;
      case AddFileItem.image:
        _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery)
            .catchError((error) {
          print('$_tag error on picking image from gallery');
          _hasError = true;
        });
        notifyListeners();
        break;
      default:
        print('$_tag the selected option was: $item');
        return null;
    }
    if (_hasError) return StatusCode.failed;
    return StatusCode.success;
  }

  StorageReference _getStorageRefFor(FileUploadFor uploadFor, String uuid) {
    switch (uploadFor) {
      case FileUploadFor.chat:
        return _storage.ref().child(BUCKET_CHAT_IMAGE).child('$uuid.jpg');
        break;

      case FileUploadFor.forum:
        return _storage.ref().child(BUCKET_FORUM_IMAGE).child('$uuid.jpg');
        break;
      case FileUploadFor.ad:
        return _storage.ref().child(BUCKET_AD_IMAGE).child('$uuid.jpg');
        break;
      case FileUploadFor.user:
        return _storage.ref().child(BUCKET_USER_IMAGE).child('$uuid.jpg');
        break;
      default:
        print('$_tag unexpected uploadFor: $uploadFor');
        return null;
    }
  }

  /// uploads a file to the firebase cloud storage bucket then
  /// updates a firebase firestore document provided
  /// the [fileUploadFor] is an enum pf type [FileUploadFor]
  /// it describes the purpose of the upload and specifies which bucked to place the
  /// file in based on the purpose
  /// the [target] can be of either type [Forum],[Ad], [User] or [Chat] based on the purpose
  /// of the uplaod.
  ///
  /// The [uploadFor] and [target] are coupled as follows:
  /// [FileUploadFor.chat] will always have a target of type [Chat]
  /// [FileUploadFor.forum] will always have a target of type [Question]
  /// [FileUploadFor.user] will always have a target of type [User]
  /// [FileUploadFor.ad] will always have a target of type [Ad]
  ///
  /// coupling that don't match this pattern will throw an error and cause
  /// [uplaodFile] to return a [StatusCode.failed].
  Future<StatusCode> uploadFile(FileUploadFor uploadFor, var target) async {
    print('$_tag at uploadFile');
    _uploadStatus = StatusCode.waiting;
    notifyListeners();
    bool _hasError = false;
    final String uuid = Uuid().v1();

    final File file = _imageFile; //TODO: account for video files as well
    final StorageReference ref = _getStorageRefFor(uploadFor, uuid);

    final StorageUploadTask uploadTask = ref.putFile(
      file,
      StorageMetadata(
        contentLanguage: 'en',
        customMetadata: <String, String>{'activity': 'magari'},
      ),
    );

    _tasks.add(uploadTask);

    StorageTaskSnapshot snapshot =
        await uploadTask.onComplete.catchError((error) {
      print('$_tag error on uploading recording: $error');
      _hasError = true;
      _uploadStatus = StatusCode.failed;
      notifyListeners();
    });
    if (_hasError) return StatusCode.failed;
    _fileUrl = await snapshot.ref.getDownloadURL();
    _filePath = await snapshot.ref.getPath();
    _resetFileField();
    notifyListeners();
    _uploadStatus = await _updateTargetWithFileUrl(uploadFor, target);
    notifyListeners();
    return _uploadStatus;
  }

  _resetFileField() {
    _imageFile = null;
  }

  DocumentReference _getTargetRef(FileUploadFor uploadFor, var target) {
    switch (uploadFor) {
      case FileUploadFor.chat:
        return _database.collection(COLLECTIONS_CHATS).document(target.id);
        break;
      case FileUploadFor.forum:
        return _database.collection(COLLECTION_QUESTIONS).document(target.id);
        break;
      case FileUploadFor.user:
        return _database.collection(COLLECTION_USERS).document(target.id);
        break;
      case FileUploadFor.ad:
        return _database.collection(COLLECTION_ADS).document(target.id);
        break;
      default:
        print('$_tag unexpected uloadFor: $uploadFor');
        return null;
    }
  }

  Map<String, dynamic> _getMap(FileUploadFor uploadFor) {
    switch (uploadFor) {
      case FileUploadFor.chat:
        return {
          FIELD_FILE_URL: _fileUrl,
          FIELD_FILE_PATH: _filePath,
          FIELD_FILE_STATUS: FILE_STATUS_UPLOAD_SUCCESS
        };
        break;
      case FileUploadFor.ad:
      case FileUploadFor.user:
        return {
          FIELD_IMAGE_URL: _fileUrl,
          FIELD_IMAGE_PATH: _filePath,
          FIELD_FILE_STATUS: FILE_STATUS_UPLOAD_SUCCESS
        };
        break;
      default:
        print('$_tag unexpected uploadFor: $uploadFor');
        return {};
    }
  }

  Future<StatusCode> _updateTargetWithFileUrl(
      FileUploadFor uploadFor, var target) async {
    print('$_tag at _updateChatWithFileUrl');
    bool _hasError = false;
    Map<String, dynamic> updateTargetMap = _getMap(uploadFor);

    await _getTargetRef(uploadFor, target)
        .updateData(updateTargetMap)
        .catchError((error) {
      print('$_tag error on updating target with uploaded file: $error');
      _hasError = true;
    });
    if (_hasError) return StatusCode.failed;
    return StatusCode.success;
  }

  Future<StatusCode> deleteAsset(String path) async {
    print('$_tag at deleteAsset');
    bool _hasError = false;
    _storage.ref().child(path).delete().catchError((error) {
      print('$_tag error on deleting file');
      _hasError = true;
    });
    if (_hasError) return StatusCode.failed;
    return StatusCode.success;
  }
}
