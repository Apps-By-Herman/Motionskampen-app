import 'package:flutter/widgets.dart';
import 'package:moveness/dtos/requests/reply_challenge.dart';
import 'package:moveness/locator.dart';
import 'package:moveness/models/challenge.dart';
import 'package:moveness/services/api.dart';

class ChallengeProvider extends ChangeNotifier {
  final _api = locator<ApiService>();

  List<Challenge>? _challenges;

  List<Challenge>? get challenges => _challenges;

  List<Challenge>? _finishedChallenges;

  List<Challenge>? get finishedChallenges => _finishedChallenges;

  Challenge? _challenge;

  Challenge? get challenge => _challenge;

  Future getChallenges(bool accepted) async {
    var response = await _api.challenges(accepted);
    if (response.isSuccess()) {
      _challenges = response.getResult()!.challenges;
      notifyListeners();
    }
  }

  Future getFinishedChallenges() async {
    var response = await _api.finishedChallenges(null);
    if (response.isSuccess()) {
      _finishedChallenges = response.getResult()!.challenges;
      notifyListeners();
    }
  }

  Future getChallenge(int id) async {
    var response = await _api.challenge(id);
    if (response.isSuccess()) {
      _challenge = response.getResult();
      notifyListeners();
    }
  }

  Future replyChallenge(int challengeId, ReplyChallengeRequest request) async {
    var response = await _api.replyChallenge(challengeId, request);
    if (response.isSuccess()) {
      notifyListeners();
      getChallenges(false);
    }

    return response;
  }

  void clear() {
    _challenge = null;
    _challenges = null;
    _finishedChallenges = null;
  }
}
