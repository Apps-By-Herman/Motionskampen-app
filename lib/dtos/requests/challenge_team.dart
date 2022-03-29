class ChallengeTeamRequest {
  int? challengedTeamId;
  int? challengingTeamId;

  ChallengeTeamRequest({
    this.challengedTeamId,
    this.challengingTeamId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['challengedTeamId'] = this.challengedTeamId;
    data['challengingTeamId'] = this.challengingTeamId;
    return data;
  }
}
