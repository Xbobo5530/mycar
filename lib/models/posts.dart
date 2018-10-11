class Posts {
  String id, description, userId;
  int createdAt;

  /// the user image url will be fetched from the user details
  /// just in case the user decides to change the user image
  ///
  /// the comments will be contained within a collection within
  /// the thread document
  /// they can be fetched separetly

  Posts({this.description, this.id, this.userId, this.createdAt});

  Posts.fromSnapshot(var value) {
//    this.id = value['id'];
    ///the id will be inserted dynamically
    /// as the Thread objects are created
    this.description = value['description'];
    this.userId = value['user_id'];
    this.createdAt = value['created_at'];
  }
}
