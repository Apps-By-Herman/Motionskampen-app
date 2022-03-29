import 'package:flutter/widgets.dart';
import 'package:moveness/dtos/requests/create_activity.dart';
import 'package:moveness/locator.dart';
import 'package:moveness/models/activity.dart';
import 'package:moveness/services/api.dart';

class ActivityProvider extends ChangeNotifier {
  final _api = locator<ApiService>();

  List<Activity>? _activities;

  List<Activity>? get activities => _activities;

  int _activeMinutesToday = 0;

  int get activeMinutesToday => _activeMinutesToday;

  Future get() async {
    var response = await _api.activities();
    if (response.isSuccess()) {
      _activities = response.getResult()!.activities;
      _activeMinutesToday = _activities!.fold(0, (p, c) => p + c.activeMinutes);
      notifyListeners();
    }
  }

  Future<ApiResponse> createActivity(
      CreateActivityRequest request) async {
    var response = await _api.createActivity(request);
    if (response.isSuccess()) {
      get();
    }

    return response;
  }

  void clear() {
    _activities = null;
    _activeMinutesToday = 0;
  }
}
