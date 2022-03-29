import 'package:flutter/material.dart';
import 'package:moveness/app_theme.dart';
import 'package:moveness/models/activity.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage(this.activity, {Key? key}) : super(key: key);
  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Aktivitet')),
      body: Padding(
        padding: EdgeInsets.all(ThemeSettings.getMainPadding()),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${activity.created.toString().substring(0, 19)}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ThemeSettings.textColor,
              ),
            ),

            SizedBox(height: ThemeSettings.getMainPadding()),
          ],
        ),
      ),
    );
  }
}
