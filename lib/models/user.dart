class User {
  String id, name, imageUrl, bio;
  int createdAt;

  User({this.name, this.bio, this.imageUrl, this.createdAt});

  User.fromSnapshot(var value) {
    this.name = value['name'];
    this.bio = value['bio'];
    this.createdAt = value['created_at'];
    this.imageUrl = value['image_url'];
  }
}
