class Question {
  String id, userId;
  int createdAt;

  /// the user image url will be fetched from the user details
  /// just in case the user decides to change the user image
  ///
  /// the comments will be contained within a collection within
  /// the thread document
  /// they can be fetched separately

  Question({this.id, this.userId, this.createdAt});

  Question.fromSnapshot(var value) {
//    this.id = value['id'];
    ///the id will be inserted dynamically
    /// as the Thread objects are created
    this.userId = value['user_id'];
    this.createdAt = value['created_at'];
  }
}
