class Me {
  late String id;
  late String profileImageURL;
  late bool emailConfirmed;
  late String email;
  late String username;

  Me({
    required this.id,
    required this.profileImageURL,
    required this.username,
    required this.email,
    required this.emailConfirmed,
  });

  Me.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profileImageURL = json['profileImageURL'];
    username = json['username'];
    email = json['email'];
    emailConfirmed = json['emailConfirmed'];
  }
}
