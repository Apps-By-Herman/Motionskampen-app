import 'package:moveness/dtos/requests/register.dart';
import 'package:moveness/locator.dart';
import 'package:moveness/services/api.dart';
import 'package:moveness/services/storage.dart';
import 'package:moveness/misc/extensions.dart';

class AuthService {
  final _storage = locator<StorageService>();

  String? _accessToken;
  String? get accessToken => _accessToken;

  DateTime _expiryDate = DateTime.now().toUtc();
  DateTime get expiryDate => _expiryDate;

  bool hasAccessToken() => _accessToken?.isNullOrEmpty == false;

  Function()? _onLogout;

  void onLogout(Function() callback) {
    _onLogout = callback;
  }

  Function()? _onLogin;

  void onLogin(Function() callback) {
    _onLogin = callback;
  }

  Future<void> setTokens(String accessToken, int expiry) async {
    _accessToken = accessToken;
    var expiryDate = DateTime.now().toUtc().add(Duration(minutes: expiry));
    _expiryDate = expiryDate;

    await Future.wait([
      _storage.writeAccessToken(accessToken),
      _storage.writeExpiry(expiryDate)
    ]);
  }

  Future<bool> login(String username, String password) async {
    final _api = locator<ApiService>();
    var response = await _api.login(username, password);
    if (response.isSuccess()) {
      var result = response.getResult()!;
      setTokens(result.token, result.expiry);
      if (_onLogin != null) await _onLogin!();
      return true;
    }
    return false;
  }

  Future<ApiResponse> register(RegisterRequest request) async {
    final _api = locator<ApiService>();
    var response = await _api.register(request);
    if (response.isSuccess()) {
      var result = response.getResult()!;
      setTokens(result.token, result.expiry);
      if (_onLogin != null) await _onLogin!();
    }

    return response;
  }

  void logout() {
    _accessToken = '';
    _expiryDate = DateTime.now().toUtc();
    _storage.writeAccessToken('');
    if (_onLogout != null) _onLogout!();
  }

  Future<void> loadTokens() async {
    //This way they both load at the same time
    final f = await Future.wait([
      _storage.readAccessToken(),
      _storage.readExpiry()
    ]);

    _accessToken = f[0] as String?;
    _expiryDate = f[1] as DateTime;
  }
}
