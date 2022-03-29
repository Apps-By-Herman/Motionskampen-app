import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:moveness/dtos/requests/device_token.dart';
import 'package:moveness/dtos/requests/preferred_language.dart';
import 'package:moveness/locator.dart';
import 'package:moveness/services/api.dart';

class Utilities {
  static Future<void> updateDeviceToken() async {
    var token = await FirebaseMessaging.instance.getToken();

    if (token != null) {
      var request = DeviceTokenRequest(deviceToken: token);

      final _api = locator<ApiService>();
      _api.deviceToken(request);
    }
  }

  static void updatePreferredLanguage(String languageCode) {
    print("Language code is: $languageCode");
    var request = PreferredLanguageRequest(preferredLanguage: languageCode);
    final _api = locator<ApiService>();
    _api.preferredLanguage(request);
  }
}