import 'package:flutter/material.dart';
import 'package:moveness/app_theme.dart';
import 'package:moveness/providers/search.dart';
import 'package:moveness/misc/error_dialogs.dart';
import 'package:moveness/shared/empty_list_text.dart';
import 'package:moveness/shared/search_team_item.dart';
import 'package:moveness/shared/search_user_item.dart';
import 'package:moveness/shared/styled_circular_progress_indicator.dart';
import 'package:provider/provider.dart';

class SearchUserTeam extends StatefulWidget {
  SearchUserTeam(this.searchUser, this.searchUsers, {Key? key})
      : super(key: key);

  final searchUser;
  final searchUsers;

  @override
  _SearchUserTeamState createState() => _SearchUserTeamState();
}

class _SearchUserTeamState extends State<SearchUserTeam> {
  final queryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final searchProvider = Provider.of<SearchProvider>(context);

    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(ThemeSettings.getMainPadding()),
            child: Form(
              key: _formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: queryController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText:
                            widget.searchUser ? 'Användarnamn' : 'Teamnamn',
                      ),
                      validator: (value) {
                        var v = value?.trim();
                        if (v?.isEmpty == true) return "Får inte lämnas tom.";
                        return null;
                      },
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() == true) {
                        var response = await searchProvider.search(
                            queryController.text.trim(), widget.searchUser);

                        if (response.isFailure()) {
                          ErrorDialogs(response, context).show();
                        }
                      }
                    },
                    child: Text(
                      'Sök',
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          widget.searchUser
              ? Expanded(
                  child: searchProvider.searchResultUsers == null
                      ? searchProvider.firstTime
                          ? Container()
                          : Center(child: StyledCircularProgressIndicator())
                      : searchProvider.searchResultUsers!.isEmpty &&
                              !searchProvider.firstTime
                          ? EmptyListText('Hittade inga användare')
                          : ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount:
                                  searchProvider.searchResultUsers!.length,
                              itemBuilder: (context, i) => SearchUserItem(
                                  searchProvider.searchResultUsers![i],
                                  widget.searchUsers),
                            ),
                )
              : Expanded(
                  child: searchProvider.searchResultTeams == null
                      ? searchProvider.firstTime
                          ? Container()
                          : Center(child: StyledCircularProgressIndicator())
                      : searchProvider.searchResultTeams!.isEmpty &&
                              !searchProvider.firstTime
                          ? EmptyListText('Hittade inga team')
                          : ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount:
                                  searchProvider.searchResultTeams!.length,
                              itemBuilder: (context, i) => SearchTeamItem(
                                searchProvider.searchResultTeams![i],
                              ),
                            ),
                ),
        ],
      ),
    );
  }
}
