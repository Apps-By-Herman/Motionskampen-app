import 'package:flutter/material.dart';
import 'package:moveness/app_theme.dart';
import 'package:moveness/models/activity.dart';
import 'package:moveness/models/challenge.dart';
import 'package:moveness/providers/me.dart';
import 'package:moveness/shared/challenge_item.dart';
import 'package:moveness/shared/empty_list_text.dart';
import 'package:moveness/shared/heading.dart';
import 'package:moveness/shared/styled_circular_progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:moveness/misc/extensions.dart';

class ChallengePage extends StatefulWidget {
  const ChallengePage(this.challenge, {Key? key}) : super(key: key);
  final Challenge? challenge;

  @override
  _ChallengePageState createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<MeProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final meProvider = Provider.of<MeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Utmaning')),
      body: widget.challenge == null || meProvider.me == null
          ? Center(child: StyledCircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.challenge!.accepted == null &&
                        widget.challenge!.challengedUserId == meProvider.me!.id
                    ? Center(
                        child: Column(
                          children: [],
                        ),
                      )
                    : Container(),
                ChallengeWidget(widget.challenge!, false),
                SizedBox(height: ThemeSettings.getMainPadding()),
                widget.challenge!.accepted == null
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.fromLTRB(
                          ThemeSettings.getMainPadding(),
                          0,
                          ThemeSettings.getMainPadding(),
                          0,
                        ),
                        child: Column(
                          children: [
                            if (DateTime.now().millisecondsSinceEpoch >
                                widget.challenge!.endTime.millisecondsSinceEpoch)
                              Text('Slutade: '
                                  '${_getEndTime(widget.challenge!.endTime)}')
                            else
                              Text(
                                  'Slutar: ${_getEndTime(widget.challenge!.endTime)}'),
                            SizedBox(height: ThemeSettings.getMainPadding()),
                          ],
                        ),
                      ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    ThemeSettings.getMainPadding(),
                    0,
                    ThemeSettings.getMainPadding(),
                    ThemeSettings.getMainPadding(),
                  ),
                  child: Center(
                      child: Heading(
                          'Senaste aktiviteter', ThemeSettings.textColor)),
                ),
                Expanded(
                  child: widget.challenge!.latestActivities.isEmpty
                      ? EmptyListText('Finns inga aktiviteter.')
                      : ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: widget.challenge!.latestActivities.length,
                          itemBuilder: (context, i) => _ActivityItem(
                              widget.challenge!.latestActivities[i]),
                        ),
                ),
              ],
            ),
    );
  }

  String _getEndTime(DateTime endTime) {
    return "${_getWeekday(endTime.weekday)} den ${endTime.day} "
        "${_getMonth(endTime.month)}";
  }

  String _getWeekday(int wd) {
    var weekday;
    if (wd == 0)
      weekday = "Söndag";
    else if (wd == 1)
      weekday = "Måndag";
    else if (wd == 2)
      weekday = "Tisdag";
    else if (wd == 3)
      weekday = "Onsdag";
    else if (wd == 4)
      weekday = "Torsdag";
    else if (wd == 5)
      weekday = "Fredag";
    else
      weekday = "Lördag";

    return weekday;
  }

  String _getMonth(int month) {
    var m;
    if (month == 1)
      m = "januari";
    else if (month == 2)
      m = "februari";
    else if (month == 3)
      m = "mars";
    else if (month == 4)
      m = "april";
    else if (month == 5)
      m = "maj";
    else if (month == 6)
      m = "juni";
    else if (month == 7)
      m = "juli";
    else if (month == 8)
      m = "augusti";
    else if (month == 9)
      m = "september";
    else if (month == 10)
      m = "oktober";
    else if (month == 11)
      m = "november";
    else
      m = "december";

    return m;
  }
}

class _ActivityItem extends StatelessWidget {
  const _ActivityItem(this.activity, {Key? key}) : super(key: key);
  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: ThemeSettings.getMainPadding()),
      child: Container(
        color: ThemeSettings.grayColor,
        child: Padding(
          padding: EdgeInsets.all(ThemeSettings.getMainPadding()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_getDateString(activity.created)} - '
                '${activity.created.toLocal().toString().substring(0, 19)}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: ThemeSettings.textColor,
                ),
              ),
              SizedBox(height: ThemeSettings.getMainPadding()),
              Text(
                  '${activity.activeMinutes.toString()} poäng för ${activity.name.toLowerCase()} av ${activity.username}'),
            ],
          ),
        ),
      ),
    );
  }

  String _getDateString(DateTime created) {
    var now = DateTime.now().toUtc();
    var daysAgo;

    if (now.isSameDate(created)) {
      daysAgo = "Idag";
    } else if (isYesterday(created)) {
      daysAgo = "Igår";
    } else {
      var diff;
      if (now.year >= created.toUtc().year &&
          now.month >= created.toUtc().month &&
          now.day >= created.toUtc().day &&
          now.hour >= created.toUtc().hour &&
          now.minute >= created.toUtc().minute) {
        diff = now.difference(created).inDays;
      } else {
        diff = now.difference(created).inDays + 1;
      }

      daysAgo = "${diff.toString()} dagar sen";
    }

    return daysAgo;
  }

  bool isYesterday(DateTime d) {
    var yesterday = DateTime.now().toUtc().subtract(Duration(days: 1));

    return yesterday.year == d.year &&
        yesterday.month == d.month &&
        yesterday.day == d.day;
  }
}
