class RemoveTeamMemberRequest {
  String id;
  int teamId;

  RemoveTeamMemberRequest({required this.id, required this.teamId });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['teamId'] = this.teamId;
    return data;
  }
}