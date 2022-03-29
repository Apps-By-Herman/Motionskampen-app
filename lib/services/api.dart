import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:moveness/dtos/requests/add_team_members.dart';
import 'package:moveness/dtos/requests/challenge_private.dart';
import 'package:moveness/dtos/requests/challenge_random_team.dart';
import 'package:moveness/dtos/requests/challenge_team.dart';
import 'package:moveness/dtos/requests/confirm_reset_password.dart';
import 'package:moveness/dtos/requests/create_activity.dart';
import 'package:moveness/dtos/requests/create_team.dart';
import 'package:moveness/dtos/requests/device_token.dart';
import 'package:moveness/dtos/requests/leave_team.dart';
import 'package:moveness/dtos/requests/preferred_language.dart';
import 'package:moveness/dtos/requests/register.dart';
import 'package:moveness/dtos/requests/remove_team_member.dart';
import 'package:moveness/dtos/requests/reply_challenge.dart';
import 'package:moveness/dtos/requests/reset_password.dart';
import 'package:moveness/dtos/requests/search.dart';
import 'package:moveness/dtos/responses/activities.dart';
import 'package:moveness/dtos/responses/challenges.dart';
import 'package:moveness/dtos/responses/login.dart';
import 'package:moveness/dtos/responses/teams.dart';
import 'package:moveness/dtos/responses/users.dart';
import 'package:moveness/locator.dart';
import 'package:moveness/models/challenge.dart';
import 'package:moveness/models/me.dart';
import 'package:moveness/models/team.dart';
import 'package:moveness/services/auth.dart';

class ApiService {
  static const String _baseUrl = 'https://motionskampen.azurewebsites.net/api';
  final _auth = locator<AuthService>();

  Future<http.Response> _get(String url, {Map<String, String>? headers}) async {
    _checkRenewAccessToken(url);

    if (headers == null) headers = new Map<String, String>();
    headers.putIfAbsent("Authorization", () => "Bearer ${_auth.accessToken}");

    var sw = new Stopwatch();
    print("API REQUEST GET: $url");
    sw.start();
    final response = await http.get(
      Uri.parse(_baseUrl + url),
      headers: headers,
    );
    sw.stop();
    print('API RESPONSE GET: $url - StatusCode: ${response.statusCode}'
        ' ${sw.elapsedMilliseconds}ms');

    return response;
  }

  Future<http.Response> _post(String url,
      {Map<String, String>? headers, dynamic body, bool useAuth = true}) async {
    _checkRenewAccessToken(url);

    if (headers == null) {
      headers = new Map<String, String>();
    }

    if (useAuth)
      headers.putIfAbsent("Authorization", () => "Bearer ${_auth.accessToken}");

    headers.putIfAbsent("Content-Type", () => "application/json");

    var sw = new Stopwatch();
    print("API REQUEST POST: $url");
    sw.start();
    final response = await http.post(
      Uri.parse(_baseUrl + url),
      headers: headers,
      body: body,
    );
    sw.stop();
    print('API RESPONSE POST: $url - StatusCode: ${response.statusCode}'
        ' ${sw.elapsedMilliseconds}ms');

    print('API RESPONSE POST: $url - Response: ${response.body}');

    return response;
  }

  Future<http.Response> _put(String url,
      {Map<String, String>? headers, dynamic body}) async {
    _checkRenewAccessToken(url);

    if (headers == null) headers = new Map<String, String>();

    headers.putIfAbsent("Authorization", () => "Bearer ${_auth.accessToken}");
    headers.putIfAbsent("Content-Type", () => "application/json");

    var sw = new Stopwatch();
    print("API REQUEST PUT: $url");
    sw.start();
    final response = await http.put(
      Uri.parse(_baseUrl + url),
      headers: headers,
      body: body,
    );
    sw.stop();
    print('API RESPONSE PUT: $url - StatusCode:${response.statusCode}'
        ' ${sw.elapsedMilliseconds}ms');

    return response;
  }

  Future<http.Response> _delete(String url, {dynamic body}) async {
    _checkRenewAccessToken(url);

    final client = http.Client();
    try {
      var sw = new Stopwatch();
      print("API REQUEST DELETE: $url");
      sw.start();

      var response;
      if (body == null) {
        var headers = new Map<String, String>();
        headers.putIfAbsent(
            "Authorization", () => "Bearer ${_auth.accessToken}");
        response = await http.delete(Uri.parse(_baseUrl + url),
            headers: headers);
      } else {
        final streamedResponse =
            await client.send(http.Request("DELETE", Uri.parse(_baseUrl + url))
              ..headers["Authorization"] = "Bearer ${_auth.accessToken}"
              ..headers["Content-Type"] = "application/json"
              ..body = body);

        response = await http.Response.fromStream(streamedResponse);
      }

      sw.stop();
      print('API RESPONSE DELETE: $url - StatusCode:${response.statusCode}'
          ' ${sw.elapsedMilliseconds}ms');

      return response;
    } finally {
      client.close();
    }
  }

  Future<ApiResponse<LoginResponse>> login(
      String username, String password) async {
    final encoded = base64.encode(utf8.encode('$username:$password'));

    final response = await _post('/Account/Login',
        headers: {"Authorization": "Basic $encoded"}, useAuth: false);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse(
        response.statusCode,
        results: LoginResponse.fromJson(json.decode(response.body)),
      );
    }

    return _makeError(response);
  }

  Future<ApiResponse<LoginResponse>> register(RegisterRequest request) async {
    final response = await _post('/Account/Register',
        body: jsonEncode(request), useAuth: false);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse(
        response.statusCode,
        results: LoginResponse.fromJson(json.decode(response.body)),
      );
    }

    return _makeError(response);
  }

  Future<ApiResponse<int>> createActivity(CreateActivityRequest request) async {
    final response = await _post(
      '/Activities',
      body: jsonEncode(request),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse(response.statusCode,
          results: int.parse(response.body));
    }

    return _makeError(response);
  }

  Future<ApiResponse<int>> replyChallenge(
      int id, ReplyChallengeRequest request) async {
    final response = await _put(
      '/Challenges/$id/Reply',
      body: jsonEncode(request),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse(response.statusCode,
          results: int.parse(response.body));
    }

    return _makeError(response);
  }

  Future<ApiResponse<int>> createTeam(CreateTeamRequest request) async {
    final response = await _post(
      '/Teams',
      body: jsonEncode(request),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse(
        response.statusCode,
        results: int.parse(response.body),
      );
    }

    return _makeError(response);
  }

  Future<ApiResponse<UsersResponse>> searchUser(SearchRequest request) async {
    final response = await _post(
      '/Users/Search',
      body: jsonEncode(request),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse(
        response.statusCode,
        results: UsersResponse.fromJson(json.decode(response.body)),
      );
    }

    return _makeError(response);
  }

  Future<ApiResponse<TeamsResponse>> searchTeam(SearchRequest request) async {
    final response = await _post(
      '/Teams/Search',
      body: jsonEncode(request),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse(
        response.statusCode,
        results: TeamsResponse.fromJson(json.decode(response.body)),
      );
    }

    return _makeError(response);
  }

  Future<ApiResponse<int>> challengeUser(ChallengeUserRequest request) async {
    final response = await _post(
      '/Challenges/User',
      body: jsonEncode(request),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse(
        response.statusCode,
        results: int.parse(response.body),
      );
    }

    return _makeError(response);
  }

  Future<ApiResponse<int>> challengeRandomUser() async {
    final response = await _post('/Challenges/User/Random');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse(
        response.statusCode,
        results: int.parse(response.body),
      );
    }

    return _makeError(response);
  }

  Future<ApiResponse<int>> challengeTeam(ChallengeTeamRequest request) async {
    final response = await _post(
      '/Challenges/Team',
      body: jsonEncode(request),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse(
        response.statusCode,
        results: int.parse(response.body),
      );
    }

    return _makeError(response);
  }

  Future<ApiResponse<int>> challengeRandomTeam(
      ChallengeRandomTeamRequest request) async {
    final response = await _post(
      '/Challenges/Team',
      body: jsonEncode(request),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse(
        response.statusCode,
        results: int.parse(response.body),
      );
    }

    return _makeError(response);
  }

  Future<ApiResponse<ChallengesResponse>> challenges(bool accepted) async {
    http.Response response;

    response = await _get('/Challenges?accepted=$accepted');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse(
        response.statusCode,
        results: ChallengesResponse.fromJson(json.decode(response.body)),
      );
    }

    return _makeError(response);
  }

  Future<ApiResponse<ChallengesResponse>> finishedChallenges(
      bool? accepted) async {
    final response = await _get('/Challenges/Finished');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse(
        response.statusCode,
        results: ChallengesResponse.fromJson(json.decode(response.body)),
      );
    }

    return _makeError(response);
  }

  Future<ApiResponse<Challenge>> challenge(int id) async {
    final response = await _get('/Challenges/$id');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse(
        response.statusCode,
        results: Challenge.fromJson(json.decode(response.body)),
      );
    }

    return _makeError(response);
  }

  Future<ApiResponse<Team>> team(int id) async {
    final response = await _get('/Teams/$id');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse(
        response.statusCode,
        results: Team.fromJson(json.decode(response.body)),
      );
    }

    return _makeError(response);
  }

  Future<ApiResponse<Me>> me() async {
    final response = await _get('/Users/Me');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse(
        response.statusCode,
        results: Me.fromJson(json.decode(response.body)),
      );
    }

    return _makeError(response);
  }

  Future<ApiResponse<TeamsResponse>> teams() async {
    final response = await _get('/Teams');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse(
        response.statusCode,
        results: TeamsResponse.fromJson(json.decode(response.body)),
      );
    }

    return _makeError(response);
  }

  Future<ApiResponse<LoginResponse>> renewAccessToken() async {
    final response = await _get(
      '/api/v1/Account/RenewAccessToken',
      headers: {"Authorization": "Bearer ${_auth.accessToken}"},
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse(
        response.statusCode,
        results: LoginResponse.fromJson(json.decode(response.body)),
      );
    }

    return _makeError(response);
  }

  Future<ApiResponse<ActivitiesResponse>> activities() async {
    final response = await _get('/Activities?today=true');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse(
        response.statusCode,
        results: ActivitiesResponse.fromJson(json.decode(response.body)),
      );
    }

    return _makeError(response);
  }

  Future<ApiResponse> removeTeamMember(
      String userId, int teamId, RemoveTeamMemberRequest request) async {
    final response = await _delete(
      '/Teams/$teamId/Members/$userId',
      body: jsonEncode(request),
    );

    if (response.statusCode >= 200 && response.statusCode < 300)
      return ApiResponse(response.statusCode);

    return _makeError(response);
  }

  Future<ApiResponse> deleteMe() async {
    final response = await _delete(
      '/Users/Me',
    );

    if (response.statusCode >= 200 && response.statusCode < 300)
      return ApiResponse(response.statusCode);

    return _makeError(response);
  }

  Future<ApiResponse> deleteTeam(int teamId) async {
    final response = await _delete(
      '/Teams/$teamId',
    );

    if (response.statusCode >= 200 && response.statusCode < 300)
      return ApiResponse(response.statusCode);

    return _makeError(response);
  }

  Future<ApiResponse> leaveTeam(int teamId, LeaveTeamRequest request) async {
    final response =
        await _post('/Teams/$teamId/Leave', body: jsonEncode(request));

    if (response.statusCode >= 200 && response.statusCode < 300)
      return ApiResponse(response.statusCode);

    return _makeError(response);
  }

  Future<ApiResponse> addTeamMembers(
      int teamId, AddTeamMemberRequest request) async {
    final response = await _post(
      '/Teams/$teamId/Members',
      body: jsonEncode(request),
    );

    if (response.statusCode >= 200 && response.statusCode < 300)
      return ApiResponse(response.statusCode);

    return _makeError(response);
  }

  Future<ApiResponse> resetPassword(ResetPasswordRequest request) async {
    final response = await _post('/Account/ResetPassword',
        body: jsonEncode(request), useAuth: false);

    if (response.statusCode >= 200 && response.statusCode < 300)
      return ApiResponse(response.statusCode);

    return _makeError(response);
  }

  Future<ApiResponse> confirmResetPassword(
      ConfirmResetPasswordRequest request) async {
    final response = await _post('/Account/ConfirmResetPassword',
        body: jsonEncode(request), useAuth: false);

    if (response.statusCode >= 200 && response.statusCode < 300)
      return ApiResponse(response.statusCode);

    return _makeError(response);
  }

  Future<ApiResponse> deviceToken(DeviceTokenRequest request) async {
    final response = await _put(
      '/Users/Me/DeviceToken',
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode >= 200 && response.statusCode < 300)
      return ApiResponse(response.statusCode);

    return _makeError(response);
  }

  Future<ApiResponse> preferredLanguage(
      PreferredLanguageRequest request) async {
    final response = await _put(
      '/Users/Me/PreferredLanguage',
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode >= 200 && response.statusCode < 300)
      return ApiResponse(response.statusCode);

    return _makeError(response);
  }

  void _checkRenewAccessToken(String url) async {
    if (url == "/Account/Login" ||
        url == "/Account/Register" ||
        url == "/Account/ResetPassword" ||
        url == "/Account/ConfirmResetPassword") {
      return;
    }

    var expiryDate = _auth.expiryDate;
    var now = DateTime.now().toUtc();
    var difference = expiryDate.difference(now);

    if (difference.isNegative) {
      _auth.logout();
    } else if (difference.inDays < 30) {
      var result = await renewAccessToken();
      if (result.isSuccess()) {
        var tokens = result.getResult()!;
        final accessToken = tokens.token;
        final expiry = tokens.expiry;
        _auth.setTokens(accessToken, expiry);
      } else {
        _auth.logout();
      }
    }
  }
}

ApiResponse<T> _makeError<T>(http.Response response) {
  ErrorObject errorObject;
  try {
    errorObject = ErrorObject.fromJson(json.decode(response.body));
  } on Exception catch (_) {
    errorObject = ErrorObject(-1);
  }

  return ApiResponse(
    response.statusCode,
    errorObject: errorObject,
    request: response.request,
  );
}

class ApiResponse<T> {
  ApiResponse(this._statusCode,
      {T? results, ErrorObject? errorObject, http.BaseRequest? request}) {
    this._results = results;
    this._errorObject = errorObject;
    this._request = request;
  }

  final int _statusCode;
  T? _results;
  ErrorObject? _errorObject;
  http.BaseRequest? _request;

  int get statusCode => _statusCode;

  bool isSuccess() => this._statusCode >= 200 && this._statusCode < 300;

  bool isFailure() => !isSuccess();

  T? getResult() {
    if (isFailure()) throw Exception("Can not get results when failure");
    return this._results;
  }

  ErrorObject? getError() {
    if (isSuccess()) throw Exception("Can not get error when success");
    return this._errorObject;
  }

  http.BaseRequest? getRequest() {
    return this._request;
  }
}

class ErrorObject {
  ErrorObject(this.errorCode);

  int? errorCode;

  ErrorObject.fromJson(Map<String, dynamic> json) {
    errorCode = json['code'];

    if (errorCode == null) errorCode = -1;
  }
}
