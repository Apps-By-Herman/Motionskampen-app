import 'package:shared_preferences/shared_preferences.dart';
class StorageService {
  static const _firsTime = 'firstAppStart';
  static const _accessToken = 'accessToken';
  static const _expiryDate = "expiryDate";

  Future<void> writeFirstTime(bool value) async {
    final storage = await SharedPreferences.getInstance();
    await storage.setBool(_firsTime, value);
  }

  Future<bool> readFirstTime() async {
    final storage = await SharedPreferences.getInstance();

    if (!storage.containsKey(_firsTime))
      return true;

    return storage.getBool(_firsTime) == true;
  }

  Future<void> writeAccessToken(String value) async {
    final storage = await SharedPreferences.getInstance();
    await storage.setString(_accessToken, value);
  }

  Future<String?> readAccessToken() async {
    final storage = await SharedPreferences.getInstance();
    return storage.getString(_accessToken);
  }

  Future<void> writeExpiry(DateTime value) async {
    var s = value.toIso8601String();
    final storage = await SharedPreferences.getInstance();
    await storage.setString(_expiryDate, s);
  }

  Future<DateTime> readExpiry() async {
    final storage = await SharedPreferences.getInstance();
    var s = storage.getString(_expiryDate);

    if (s == null)
      return DateTime.now().toUtc();

    return DateTime.parse(s);
  }
}
