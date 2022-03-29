import 'package:moveness/models/challenge.dart';
import 'package:moveness/models/user.dart';

class Team {
  late int id;
  late String name;
  late String description;
  String? imageURL;
  late List<User> members;
  late List<Challenge> activeChallenges;
  late List<Challenge> finishedChallenges;
  late bool isOwner;

  Team({
    required this.id,
    required this.name,
    required this.description,
    this.imageURL,
    required this.members,
    required this.activeChallenges,
    required this.isOwner,
  });

  Team.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    imageURL = json['imageURL'];
    isOwner = json['isOwner'];

    var members = List<User>.empty(growable: true);
    if (json['members'] != null) {
      json['members'].forEach((v) {
        members.add(new User.fromJson(v));
      });
    }

    this.members = members;

    var activeChallenges = List<Challenge>.empty(growable: true);
    if (json['activeChallenges'] != null) {
      json['activeChallenges'].forEach((v) {
        activeChallenges.add(new Challenge.fromJson(v));
      });
    }
    this.activeChallenges = activeChallenges;

    var finishedChallenges = List<Challenge>.empty(growable: true);
    if (json['finishedChallenges'] != null) {
      json['finishedChallenges'].forEach((v) {
        finishedChallenges.add(new Challenge.fromJson(v));
      });
    }

    this.finishedChallenges = finishedChallenges;
  }
}
