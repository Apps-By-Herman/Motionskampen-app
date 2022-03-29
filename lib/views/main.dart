import 'package:flutter/material.dart';
import 'package:moveness/pages/teams.dart';
import 'package:moveness/pages/home.dart';
import 'package:moveness/pages/profile.dart';
import 'package:moveness/shared/custom_scaffold.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      onItemTap: (index) {}, //needed so we don't get error
      scaffold: Scaffold(
          bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(label: 'Hem', icon: Icon(Icons.house)),
          BottomNavigationBarItem(label: 'Teams', icon: Icon(Icons.group)),
          BottomNavigationBarItem(label: 'Profil', icon: Icon(Icons.person)),
        ],
      )),
      children: [HomePage(), TeamsPage(), ProfilePage()],
    );
  }
}
