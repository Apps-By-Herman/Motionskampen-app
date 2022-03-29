import 'package:flutter/widgets.dart';
import 'package:moveness/dtos/requests/add_team_members.dart';
import 'package:moveness/dtos/requests/create_team.dart';
import 'package:moveness/dtos/requests/leave_team.dart';
import 'package:moveness/dtos/requests/remove_team_member.dart';
import 'package:moveness/locator.dart';
import 'package:moveness/models/team.dart';
import 'package:moveness/models/user.dart';
import 'package:moveness/services/api.dart';

class TeamProvider extends ChangeNotifier {
  final _api = locator<ApiService>();

  List<Team>? _teams;
  List<Team>? get teams => _teams;

  Team? _team;
  Team? get team => _team;

  Future get() async {
    var response = await _api.teams();
    if (response.isSuccess()) {
      _teams = response.getResult()!.teams;
      notifyListeners();
    }
  }

  Future getTeam(int id) async {
    var response = await _api.team(id);
    if (response.isSuccess()) {
      _team = response.getResult();
      notifyListeners();
    }
  }

  Future createTeam (CreateTeamRequest request) async {
    var response = await _api.createTeam(request);
    if (response.isSuccess()) {
      get();
    }

    return response;
  }

  Future<ApiResponse> removeUser(User user) async {
    var request = RemoveTeamMemberRequest(id: user.id, teamId: team?.id ?? 0);
    var response = await _api.removeTeamMember(user.id, team?.id ?? 0, request);
    if (response.isSuccess()) {
      team?.members.remove(user);
      Team t = teams!.singleWhere((e) => e.id == team?.id);
      t.members.remove(user);
      notifyListeners();
    }

    return response;
  }

  Future<ApiResponse> addTeamMembers(int teamId, List<User> users) async {
    var userIds = users.map((e) => e.id).toList();

    var request = AddTeamMemberRequest(
      teamId: teamId,
      userIds: userIds,
    );

    var response = await _api.addTeamMembers(teamId, request);
    if (response.isSuccess()) {
      team?.members.addAll(users);
      Team t = teams!.singleWhere((e) => e.id == team?.id);
      t.members.addAll(users);
      notifyListeners();
    }

    return response;
  }

  Future<ApiResponse> deleteTeam() async {
    var response = await _api.deleteTeam(team?.id ?? 0);

    if (response.isSuccess()) {
      _team = null;
      get();
    }

    return response;
  }

  Future<ApiResponse> leaveTeam() async {
    var request = LeaveTeamRequest(teamId: team?.id ?? 0);
    var response = await _api.leaveTeam(team?.id ?? 0, request);

    if (response.isSuccess()) {
      _team = null;
      get();
    }

    return response;
  }

  void clear() {
    _teams = null;
    _team = null;
  }
}