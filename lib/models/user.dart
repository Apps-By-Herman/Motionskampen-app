class User {
  late String id;
  late String profileImageURL;
  late String username;

  User({
    required this.id,
    required this.profileImageURL,
    required this.username,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profileImageURL = json['profileImageURL'];
    username = json['username'];
  }
}
