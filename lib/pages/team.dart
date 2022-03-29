import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moveness/app_theme.dart';
import 'package:moveness/models/me.dart';
import 'package:moveness/models/user.dart';
import 'package:moveness/pages/add_team_member.dart';
import 'package:moveness/pages/create_challenge.dart';
import 'package:moveness/pages/finished_challenges.dart';
import 'package:moveness/providers/me.dart';
import 'package:moveness/providers/team.dart';
import 'package:moveness/misc/error_dialogs.dart';
import 'package:moveness/shared/action_dialog.dart';
import 'package:moveness/shared/challenge_item.dart';
import 'package:moveness/shared/empty_list_text.dart';
import 'package:moveness/shared/heading.dart';
import 'package:moveness/shared/styled_circular_progress_indicator.dart';
import 'package:provider/provider.dart';

class TeamPage extends StatefulWidget {
  const TeamPage(this.teamId, {Key? key}) : super(key: key);
  final int teamId;

  @override
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  bool _isButtonDisabled = false;

  @override
  void initState() {
    super.initState();
    Provider.of<TeamProvider>(context, listen: false).getTeam(widget.teamId);
  }

  @override
  Widget build(BuildContext context) {
    final meProvider = Provider.of<MeProvider>(context);
    final teamProvider = Provider.of<TeamProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title:
            teamProvider.team == null ? Text('') : Text(teamProvider.team!.name),
        actions: [
          if (teamProvider.team != null && teamProvider.team!.isOwner)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () =>
                  _isButtonDisabled ? null : _onClickRemoveTeam(teamProvider),
              color: Colors.red,
            )
          else if (teamProvider.team != null)
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () =>
                  _isButtonDisabled ? null : _onClickLeaveTeam(teamProvider),
              color: Colors.red,
            )
        ],
      ),
      body: SafeArea(
        child: teamProvider.team == null
            ? Center(child: StyledCircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  teamProvider.team?.imageURL == null
                      ? Container()
                      : Center(
                          child: Column(
                            children: [
                              SizedBox(height: ThemeSettings.getMainPadding()),
                              CachedNetworkImage(
                                imageUrl: teamProvider.team?.imageURL ?? "",
                                fit: BoxFit.cover,
                                height: 80,
                              ),
                            ],
                          ),
                        ),
                  SizedBox(height: ThemeSettings.getMainPadding()),
                  Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Text(teamProvider.team?.description ?? ""),
                  ),
                  SizedBox(height: ThemeSettings.getMainPadding()),
                  Center(
                    child: Heading('Utmaningar', ThemeSettings.textColor),
                  ),
                  SizedBox(height: ThemeSettings.getMainPadding()),
                  Expanded(
                    child: teamProvider.team?.activeChallenges == null
                        ? Center(child: StyledCircularProgressIndicator())
                        : teamProvider.team?.activeChallenges.isEmpty == true
                            ? EmptyListText('Hittade inga utmaningar.')
                            : ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount:
                                    teamProvider.team!.activeChallenges.length,
                                itemBuilder: (context, i) => ChallengeWidget(
                                  teamProvider.team!.activeChallenges[i],
                                  true,
                                ),
                              ),
                  ),
                  SizedBox(height: ThemeSettings.getMainPadding()),
                  Center(child: Heading('Medlemmar', ThemeSettings.textColor)),
                  SizedBox(height: ThemeSettings.getMainPadding()),
                  Expanded(
                    child: teamProvider.team?.members == null
                        ? Center(child: StyledCircularProgressIndicator())
                        : teamProvider.team?.members.isEmpty == true ||
                                meProvider.me == null
                            ? EmptyListText('Teamet saknar medlemmar.')
                            : ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: teamProvider.team?.members.length,
                                itemBuilder: (context, i) => _UserItem(
                                    teamProvider.team!.members[i],
                                    meProvider.me!,
                                    teamProvider),
                              ),
                  ),
                  teamProvider.team?.isOwner == false
                      ? Container()
                      : Center(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                0, ThemeSettings.getMainPadding(), 0, 0),
                            child: Column(
                              children: [
                                RaisedButton(
                                  onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AddTeamMembers(widget.teamId),
                                    ),
                                  ),
                                  child: Text("Bjud in medlemmar"),
                                ),
                                SizedBox(
                                    height: ThemeSettings.getMainPadding()),
                                RaisedButton(
                                  onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => CreateChallengePage(
                                        false,
                                        teamId: widget.teamId,
                                      ),
                                    ),
                                  ),
                                  child: Text("Utmana ett annat team"),
                                ),
                              ],
                            ),
                          ),
                        ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        0,
                        ThemeSettings.getMainPadding(),
                        0,
                        ThemeSettings.getMainPadding(),
                      ),
                      child: RaisedButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => FinishedChallengesPage(
                              teamChallenges:
                                  teamProvider.team?.finishedChallenges,
                            ),
                          ),
                        ),
                        child: Text("Avslutade utmaningar"),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }

  _onClickRemoveTeam(TeamProvider teamProvider) {
    showDialog(
      context: context,
      builder: (context) => ActionDialog(
        title: 'Ta bort team?',
        content: 'Är du säker på att du vill ta bort teamet '
            '${teamProvider.team?.name}?',
        positiveText: 'Ja',
        positive: () async {
          setState(() {
            _isButtonDisabled = true;
          });
          var response = await teamProvider.deleteTeam();

          if (response.isSuccess()) {
            Navigator.pop(context);
          } else {
            setState(() {
              _isButtonDisabled = false;
            });

            ErrorDialogs(response, context).show();
          }
        },
      ),
    );
  }

  _onClickLeaveTeam(TeamProvider teamProvider) {
    showDialog(
      context: context,
      builder: (context) => ActionDialog(
        title: 'Lämna team?',
        content: 'Är du säker på att du vill lämna teamet '
            '${teamProvider.team?.name}?',
        positiveText: 'Ja',
        positive: () async {
          setState(() {
            _isButtonDisabled = true;
          });
          var response = await teamProvider.leaveTeam();

          if (response.isSuccess()) {
            Navigator.pop(context);
          } else {
            setState(() {
              _isButtonDisabled = false;
            });

            ErrorDialogs(response, context).show();
          }
        },
      ),
    );
  }
}

class _UserItem extends StatelessWidget {
  const _UserItem(this.user, this.me, this.teamProvider, {Key? key})
      : super(key: key);
  final User user;
  final Me me;
  final TeamProvider teamProvider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        color: ThemeSettings.grayColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CachedNetworkImage(
                imageUrl: user.profileImageURL,
                fit: BoxFit.cover,
                height: 30,
              ),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(left: ThemeSettings.getMainPadding()),
                child: Text(
                  user.username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )),
              user.id == me.id || teamProvider.team?.isOwner == false
                  ? Container()
                  : IconButton(
                      icon: Icon(Icons.highlight_remove_outlined),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => ActionDialog(
                              title: 'Är du säker?',
                              content: 'Är du säker på att du vill ta bort '
                                  'användaren ${user.username}?',
                              positiveText: 'Ja',
                              positive: () async {
                                var response =
                                    await teamProvider.removeUser(user);
                                if (response.isFailure()) {
                                  ErrorDialogs(response, context).show();
                                }
                              }),
                        );
                      },
                      color: Colors.red,
                    )
            ],
          ),
        ),
      ),
    );
  }
}
