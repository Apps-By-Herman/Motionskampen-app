import 'package:flutter/material.dart';
import 'package:moveness/app_theme.dart';
import 'package:moveness/dtos/requests/create_team.dart';
import 'package:moveness/providers/search.dart';
import 'package:moveness/providers/team.dart';
import 'package:moveness/misc/error_dialogs.dart';
import 'package:moveness/shared/ok_dialog.dart';
import 'package:moveness/shared/search_user_team.dart';
import 'package:provider/provider.dart';

class CreateTeamPage extends StatefulWidget {
  @override
  _CreateTeamPageState createState() => _CreateTeamPageState();
}

class _CreateTeamPageState extends State<CreateTeamPage> {
  @override
  void initState() {
    super.initState();
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    searchProvider.clear();
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    final teamProvider = Provider.of<TeamProvider>(context, listen: false);
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    bool _isButtonDisabled = false;

    return Scaffold(
      appBar: AppBar(title: Text('Skapa team')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                ThemeSettings.getMainPadding(),
                0,
                ThemeSettings.getMainPadding(),
                0,
              ),
              child: Column(
                children: [
                  SizedBox(
                    child: TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Teamnamn',
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value?.isEmpty == true) return "Namnet får inte vara tomt!";
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: ThemeSettings.getMainPadding()),
                  SizedBox(
                    child: TextFormField(
                      controller: descriptionController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Teambeskrivning',
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      validator: (value) {
                        if (value?.isEmpty == true)
                          return "Beskrivningen får inte vara tom!";
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            SearchUserTeam(true, true),
            SizedBox(height: ThemeSettings.getMainPadding()),
            Padding(
              padding: EdgeInsets.fromLTRB(
                0,
                ThemeSettings.getMainPadding(),
                0,
                ThemeSettings.getMainPadding(),
              ),
              child: RaisedButton(
                onPressed: _isButtonDisabled
                    // ignore: dead_code
                    ? null
                    : () async {
                        if (_formKey.currentState?.validate() == true) {
                          setState(() {
                            _isButtonDisabled = true;
                          });
                          var users = searchProvider.selectedUsers;
                          var userIds = users!.map((e) => e.id).toList();
                          var teamName = nameController.text;
                          var teamDescription = descriptionController.text;

                          var request = CreateTeamRequest(
                            name: teamName,
                            description: teamDescription,
                            userIds: userIds,
                          );

                          var response = await teamProvider.createTeam(request);

                          if (response.isSuccess()) {
                            Navigator.of(context).pop();

                            showDialog(
                              context: context,
                              builder: (context) => OkDialog(
                                title: "Lyckades",
                                buttonText: "Ok",
                                content: "Ett nytt team med namn $teamName skapades.",
                              ),
                            );
                          } else {
                            setState(() {
                              _isButtonDisabled = false;
                            });

                            ErrorDialogs(response, context).show();
                          }
                        }
                      },
                child: Text('Skapa team'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
