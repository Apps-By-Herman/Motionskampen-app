import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:moveness/app_theme.dart';
import 'package:moveness/pages/create_activity.dart';
import 'package:moveness/pages/create_challenge.dart';
import 'package:moveness/pages/finished_challenges.dart';
import 'package:moveness/providers/activity.dart';
import 'package:moveness/providers/challenge.dart';
import 'package:moveness/providers/me.dart';
import 'package:moveness/shared/challenge_item.dart';
import 'package:moveness/shared/empty_list_text.dart';
import 'package:moveness/shared/styled_circular_progress_indicator.dart';
import 'package:moveness/shared/styled_refresh_indicator.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.requestPermission();

    var challengeProvider =
        Provider.of<ChallengeProvider>(context, listen: false);
    if (challengeProvider.challenges == null)
      challengeProvider.getChallenges(false);

    var activityProvider =
        Provider.of<ActivityProvider>(context, listen: false);
    if (activityProvider.activities == null) activityProvider.get();

    var meProvider = Provider.of<MeProvider>(context, listen: false);
    if (meProvider.me == null) meProvider.get();
  }

  @override
  Widget build(BuildContext context) {
    final challengeProvider = Provider.of<ChallengeProvider>(context);
    final activityProvider = Provider.of<ActivityProvider>(context);
    final meProvider = Provider.of<MeProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: StyledRefreshIndicator(
          onRefresh: () => Future.wait([
            challengeProvider.getChallenges(true),
            activityProvider.get(),
          ]),
          child: Column(
            children: [
              SizedBox(height: ThemeSettings.getMainPadding()),
              Image.asset(
                "assets/images/logo_beside.png",
                fit: BoxFit.cover,
                height: 80,
              ),
              SizedBox(height: ThemeSettings.getMainPadding()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(ThemeSettings.getMainPadding()),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'DINA POÄNG IDAG',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ThemeSettings.accentColor,
                            ),
                          ),
                          SizedBox(height: 4),
                          activityProvider.activities == null
                              ? Center(child: StyledCircularProgressIndicator())
                              : Text(
                                  "${activityProvider.activeMinutesToday} poäng",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  0,
                  ThemeSettings.getMainPadding(),
                  0,
                  0,
                ),
                child: RaisedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CreateActivityPage(),
                    ));
                  },
                  child: Text("Registrera aktivitet"),
                ),
              ),
              SizedBox(height: ThemeSettings.getMainPadding()),
              Expanded(
                child: challengeProvider.challenges == null ||
                        meProvider.me == null
                    ? Center(child: StyledCircularProgressIndicator())
                    : challengeProvider.challenges!.isEmpty
                        ? EmptyListText('Du har inga utmaningar. '
                            'Skapa en via knappen nedan.')
                        : ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: challengeProvider.challenges!.length,
                            itemBuilder: (context, i) => ChallengeWidget(
                              challengeProvider.challenges![i],
                              true,
                              showUnanswered: true,
                            ),
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
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FinishedChallengesPage(),
                  )),
                  child: Text(
                    'Avslutade utmaningar',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  0,
                  0,
                  0,
                  ThemeSettings.getMainPadding(),
                ),
                child: RaisedButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CreateChallengePage(true),
                  )),
                  child: Text(
                    'Skapa utmaning',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
