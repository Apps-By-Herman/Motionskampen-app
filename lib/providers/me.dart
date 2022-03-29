import 'package:flutter/widgets.dart';
import 'package:moveness/locator.dart';
import 'package:moveness/models/me.dart';
import 'package:moveness/services/api.dart';

class MeProvider extends ChangeNotifier {
  final _api = locator<ApiService>();

  Me? _me;
  Me? get me => _me;

  Future get() async {
    var response = await _api.me();
    if (response.isSuccess()) {
      _me = response.getResult();
      notifyListeners();
    }
  }

  Future<ApiResponse> deleteMe() async {
    var response = await _api.deleteMe();
    return response;
  }

  void clear() {
    _me = null;
  }
}