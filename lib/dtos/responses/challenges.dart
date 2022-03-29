import 'package:moveness/models/challenge.dart';

class ChallengesResponse {
  late List<Challenge> challenges;

  ChallengesResponse({required this.challenges});

  ChallengesResponse.fromJson(Map<String, dynamic> json) {
    if (json['challenges'] != null) {
      challenges = List.empty(growable: true);
      json['challenges'].forEach((v) {
        challenges.add(new Challenge.fromJson(v));
      });
    }
  }
}