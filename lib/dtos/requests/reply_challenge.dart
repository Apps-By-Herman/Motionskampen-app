class ReplyChallengeRequest {
  int id;
  bool accepted;

  ReplyChallengeRequest({required this.id, required this.accepted });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['accepted'] = this.accepted;
    return data;
  }
}