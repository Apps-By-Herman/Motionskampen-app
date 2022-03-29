class ChallengeRandomTeamRequest {
  int challengingTeamId;

  ChallengeRandomTeamRequest({required this.challengingTeamId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['challengingTeamId'] = this.challengingTeamId;
    return data;
  }
}