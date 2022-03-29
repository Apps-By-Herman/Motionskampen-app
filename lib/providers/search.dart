import 'package:flutter/widgets.dart';
import 'package:moveness/dtos/requests/search.dart';
import 'package:moveness/locator.dart';
import 'package:moveness/models/team.dart';
import 'package:moveness/models/user.dart';
import 'package:moveness/services/api.dart';

class SearchProvider extends ChangeNotifier {
  final _api = locator<ApiService>();

  List<Team>? _searchResultTeams;
  List<Team>? get searchResultTeams => _searchResultTeams;

  Team? _selectedTeam;
  Team? get selectedTeam => _selectedTeam;

  List<User>? _searchResultUsers;
  List<User>? get searchResultUsers => _searchResultUsers;

  List<User>? _selectedUsers = [];
  List<User>? get selectedUsers => _selectedUsers;

  bool _firstTime = true;
  bool get firstTime => _firstTime;

  Future<ApiResponse> search(String query, bool searchUser) async {
    _firstTime = false;

    ApiResponse response;

    if (searchUser) {
      var request = SearchRequest(query: query);
      response = await _api.searchUser(request);
      if (response.isSuccess())
        _searchResultUsers = response.getResult().users;
      else {
        _searchResultUsers = [];
      }

      notifyListeners();
    }
    else {
      var request = SearchRequest(query: query);
      response = await _api.searchTeam(request);
      if (response.isSuccess())
        _searchResultTeams = response.getResult().teams;
      else
        _searchResultTeams = [];

      notifyListeners();
    }

    return response;
  }

  void addUser(User user) async {
    if (_selectedUsers?.contains(user) == false)
      _selectedUsers!.add(user);
    notifyListeners();
  }

  void removeUser(User user) async {
    _selectedUsers?.remove(user);
    notifyListeners();
  }

  void selectTeam(Team team) async {
    _selectedTeam = team;
    notifyListeners();
  }

  void clear() {
    _firstTime = true;
    _searchResultTeams = null;
    _searchResultUsers = null;
    _selectedTeam = null;
    _selectedUsers = [];
  }
}
