class ChallengeUserRequest {
  String challengedId;

  ChallengeUserRequest({
    required this.challengedId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['challengedId'] = this.challengedId;
    return data;
  }
}
