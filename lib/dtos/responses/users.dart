import 'package:moveness/models/user.dart';

class UsersResponse {
  List<User> users = List.empty(growable: true);

  UsersResponse({required this.users});

  UsersResponse.fromJson(Map<String, dynamic> json) {
    if (json['users'] != null) {
      json['users'].forEach((v) {
        users.add(new User.fromJson(v));
      });
    }
  }
}
