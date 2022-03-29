import 'package:flutter/material.dart';
import 'package:moveness/app_theme.dart';
import 'package:moveness/dtos/requests/reply_challenge.dart';
import 'package:moveness/misc/error_dialogs.dart';
import 'package:moveness/models/challenge.dart';
import 'package:moveness/pages/challenge.dart';
import 'package:moveness/providers/challenge.dart';
import 'package:moveness/providers/me.dart';
import 'package:moveness/shared/heading.dart';
import 'package:provider/provider.dart';

class ChallengeWidget extends StatefulWidget {
  const ChallengeWidget(this.challenge, this.isClickable,
      {this.showUnanswered = false, Key? key})
      : super(key: key);
  final Challenge challenge;
  final bool isClickable;
  final bool showUnanswered;

  @override
  _ChallengeWidgetState createState() => _ChallengeWidgetState();
}

class _ChallengeWidgetState extends State<ChallengeWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final meProvider = Provider.of<MeProvider>(context);
    final challengeProvider = Provider.of<ChallengeProvider>(context);

    if (widget.showUnanswered &&
        widget.challenge.accepted == null &&
        meProvider.me != null &&
        widget.challenge.challengedUserId == meProvider.me!.id) {
      return Padding(
        padding: EdgeInsets.only(bottom: ThemeSettings.getMainPadding()),
        child: Container(
          color: ThemeSettings.grayColor,
          child: Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                0,
                ThemeSettings.getMainPadding(),
                0,
                ThemeSettings.getMainPadding(),
              ),
              child: Column(
                children: [
                  Text(
                    'Ny utmaning från ${widget.challenge.challengingName}',
                    style: TextStyle(
                      color: ThemeSettings.textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: ThemeSettings.getMainPadding()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 120,
                        child: RaisedButton(
                          child: Text(
                            'Neka',
                            overflow: TextOverflow.ellipsis,
                          ),
                          onPressed: () =>
                              _answerChallenge(false, challengeProvider),
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        child: RaisedButton(
                          child: Text(
                            'Acceptera',
                            overflow: TextOverflow.ellipsis,
                          ),
                          onPressed: () =>
                              _answerChallenge(true, challengeProvider),
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      var meIsChallenged =
          widget.challenge.challengedUserId == meProvider.me?.id;

      return Padding(
        padding: EdgeInsets.only(bottom: ThemeSettings.getMainPadding()),
        child: Container(
          color: ThemeSettings.grayColor,
          child: Padding(
            padding: EdgeInsets.all(ThemeSettings.getMainPadding()),
            child: InkWell(
              onTap: () {
                if (!widget.isClickable) return;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ChallengePage(widget.challenge),
                  ),
                );
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        color: meIsChallenged
                            ? ThemeSettings.accentColor
                            : ThemeSettings.primaryColor,
                        height: 130,
                        width: 130,
                        child: Padding(
                          padding: EdgeInsets.all(ThemeSettings.getMainPadding()),
                          child: Column(
                            children: [
                              Icon(
                                widget.challenge.isTeamChallenge
                                    ? Icons.group
                                    : Icons.person,
                                color: meIsChallenged
                                    ? ThemeSettings.primaryColor
                                    : ThemeSettings.accentColor,
                                size: 30,
                              ),
                              Center(
                                child: Text(
                                  widget.challenge.challengingName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: meIsChallenged
                                          ? ThemeSettings.primaryColor
                                          : ThemeSettings.accentColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                widget.challenge.challengingMinutes.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                ),
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),
                      ),
                      Heading("-", ThemeSettings.darkColor),
                      Container(
                        color: meIsChallenged
                            ? ThemeSettings.primaryColor
                            : ThemeSettings.accentColor,
                        height: 130,
                        width: 130,
                        child: Padding(
                          padding: EdgeInsets.all(ThemeSettings.getMainPadding()),
                          child: Column(
                            children: [
                              Icon(
                                widget.challenge.isTeamChallenge
                                    ? Icons.group
                                    : Icons.person,
                                color: meIsChallenged
                                    ? ThemeSettings.accentColor
                                    : ThemeSettings.primaryColor,
                                size: 30,
                              ),
                              Center(
                                child: Text(widget.challenge.challengedName,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: meIsChallenged
                                            ? ThemeSettings.accentColor
                                            : ThemeSettings.primaryColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis),
                              ),
                              SizedBox(height: 10),
                              Text(
                                widget.challenge.challengedMinutes.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  void _answerChallenge(
      bool accepted, ChallengeProvider challengeProvider) async {
    var request = ReplyChallengeRequest(
      id: widget.challenge.id,
      accepted: accepted,
    );

    var response =
        await challengeProvider.replyChallenge(widget.challenge.id, request);

    if (response.isSuccess()) {
      challengeProvider.getChallenges(false);
    } else {
      ErrorDialogs(response, context).show();
    }
  }
}
