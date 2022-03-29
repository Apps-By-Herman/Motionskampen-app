import 'package:moveness/models/team.dart';

class TeamsResponse {
  List<Team> teams = List.empty(growable: true);

  TeamsResponse({required this.teams});

  TeamsResponse.fromJson(Map<String, dynamic> json) {
    if (json['teams'] != null) {
      json['teams'].forEach((v) {
        teams.add(new Team.fromJson(v));
      });
    }
  }
}