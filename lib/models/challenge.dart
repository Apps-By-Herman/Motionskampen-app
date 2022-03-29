import 'package:moveness/models/activity.dart';

class Challenge {
  late int id;
  late bool? accepted;
  late DateTime startTime;
  late DateTime endTime;
  late String message;
  late String challengingUserId;
  late String challengedUserId;
  late int challengingTeamId;
  late int challengedTeamId;
  late bool isTeamChallenge;
  late String challengingName;
  late String challengedName;
  late int challengingMinutes;
  late int challengedMinutes;
  late List<Activity> latestActivities;

  Challenge(
      {required this.id,
      this.accepted,
      required this.startTime,
      required this.endTime,
      required this.message,
      required this.challengingUserId,
      required this.challengedUserId,
      required this.challengingTeamId,
      required this.challengedTeamId,
      required this.isTeamChallenge,
      required this.challengingName,
      required this.challengedName,
      required this.challengingMinutes,
      required this.challengedMinutes,
      required this.latestActivities});

  Challenge.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    accepted = json['accepted'];
    startTime = DateTime.parse(json['startTime'] + "Z");
    endTime = DateTime.parse(json['endTime'] + "Z");
    message = json['message'];
    challengingUserId = json['challengingUserId'];
    challengedUserId = json['challengedUserId'];
    challengingTeamId = json['challengingTeamId'];
    challengedTeamId = json['challengedTeamId'];
    isTeamChallenge = json['isTeamChallenge'];
    challengingName = json['challengingName'];
    challengedName = json['challengedName'];
    challengingMinutes = json['challengingMinutes'];
    challengedMinutes = json['challengedMinutes'];

    var activities = List<Activity>.empty(growable: true);
    if (json['latestActivities'] != null) {
      json['latestActivities'].forEach((v) {
        activities.add(new Activity.fromJson(v));
      });
    }

    latestActivities = activities;
  }
}
