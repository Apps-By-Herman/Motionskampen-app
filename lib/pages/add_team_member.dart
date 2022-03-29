import 'package:flutter/material.dart';
import 'package:moveness/app_theme.dart';
import 'package:moveness/providers/search.dart';
import 'package:moveness/providers/team.dart';
import 'package:moveness/misc/error_dialogs.dart';
import 'package:moveness/shared/ok_dialog.dart';
import 'package:moveness/shared/search_user_team.dart';
import 'package:provider/provider.dart';

class AddTeamMembers extends StatefulWidget {
  const AddTeamMembers(this.teamId, {Key? key}) : super(key: key);
  final int teamId;

  @override
  _AddTeamMembersState createState() => _AddTeamMembersState();
}

class _AddTeamMembersState extends State<AddTeamMembers> {
  bool _isButtonDisabled = false;

  @override
  void initState() {
    super.initState();
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    searchProvider.clear();
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    final teamProvider = Provider.of<TeamProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bjud in medlemmar',
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Column(
        children: [
          SearchUserTeam(true, true),
          Padding(
            padding: EdgeInsets.fromLTRB(
              0,
              ThemeSettings.getMainPadding(),
              0,
              ThemeSettings.getMainPadding(),
            ),
            child: _isButtonDisabled
                ? null
                : RaisedButton(
                    onPressed: () async {
                      var users = searchProvider.selectedUsers;

                      //Manual validation
                      if (users?.isEmpty == true) {
                        showDialog(
                          context: context,
                          builder: (context) => OkDialog(
                            title: "Ingen användare",
                            content:
                                "Du måste välja någon användare att bjuda in.",
                            buttonText: "Ok",
                          ),
                        );
                        return;
                      }

                      setState(() {
                        _isButtonDisabled = true;
                      });

                      var response = await teamProvider.addTeamMembers(
                          widget.teamId, users ?? List.empty());

                      if (response.isSuccess())
                        Navigator.of(context).pop();
                      else {
                        setState(() {
                          _isButtonDisabled = false;
                        });

                        ErrorDialogs(response, context).show();
                      }
                    },
                    child: Text(
                      'Bjud in',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
