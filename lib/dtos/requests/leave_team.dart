class LeaveTeamRequest {
  int teamId;

  LeaveTeamRequest({required this.teamId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['teamId'] = this.teamId;
    return data;
  }
}