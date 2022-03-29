import 'package:flutter/material.dart';
import 'package:moveness/app_theme.dart';
import 'package:moveness/models/team.dart';
import 'package:moveness/pages/create_team.dart';
import 'package:moveness/pages/team.dart';
import 'package:moveness/providers/team.dart';
import 'package:moveness/shared/empty_list_text.dart';
import 'package:moveness/shared/styled_circular_progress_indicator.dart';
import 'package:moveness/shared/styled_refresh_indicator.dart';
import 'package:provider/provider.dart';

class TeamsPage extends StatefulWidget {
  @override
  _TeamsPageState createState() => _TeamsPageState();
}

class _TeamsPageState extends State<TeamsPage> {
  @override
  void initState() {
    super.initState();
    var teamProvider = Provider.of<TeamProvider>(context, listen: false);
    if (teamProvider.teams == null) teamProvider.get();
  }

  @override
  Widget build(BuildContext context) {
    final teamProvider = Provider.of<TeamProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Teams")),
      body: SafeArea(
        child: StyledRefreshIndicator(
          onRefresh: () => teamProvider.get(),
          child: Column(
            children: [
              Expanded(
                child: teamProvider.teams == null
                    ? Center(child: StyledCircularProgressIndicator())
                    : teamProvider.teams!.isEmpty
                        ? EmptyListText('Du är inte medlem i något team.')
                        : ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: teamProvider.teams!.length,
                            itemBuilder: (context, i) =>
                                _TeamWidget(teamProvider.teams![i]),
                          ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  0,
                  ThemeSettings.getMainPadding(),
                  0,
                  ThemeSettings.getMainPadding(),
                ),
                child: RaisedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CreateTeamPage(),
                    ),
                  ),
                  child: Text('Skapa nytt team'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TeamWidget extends StatelessWidget {
  const _TeamWidget(this.team, {Key? key}) : super(key: key);
  final Team team;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        color: ThemeSettings.grayColor,
        child: InkWell(
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => TeamPage(team.id))),
          child: Padding(
            padding: EdgeInsets.all(ThemeSettings.getMainPadding()),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    team.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Spacer(),
                Text('${team.members.length.toString()} medlemmar'),
                Icon(Icons.arrow_forward_ios_sharp)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
