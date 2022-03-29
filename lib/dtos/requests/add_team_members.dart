class AddTeamMemberRequest {
  int teamId;
  List<String> userIds;

  AddTeamMemberRequest({
    required this.teamId,
    required this.userIds,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['teamId'] = this.teamId;
    data['userIds'] = this.userIds;
    return data;
  }
}
