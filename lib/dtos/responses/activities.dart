import 'package:moveness/models/activity.dart';

class ActivitiesResponse {
  List<Activity> activities = List.empty(growable: true);

  ActivitiesResponse({required this.activities});

  ActivitiesResponse.fromJson(Map<String, dynamic> json) {
    if (json['activities'] != null) {
      json['activities'].forEach((v) {
        activities.add(new Activity.fromJson(v));
      });
    }
  }
}