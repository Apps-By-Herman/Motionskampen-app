import 'package:flutter/material.dart';
ThemeData getAppTheme() => ThemeData(
      primaryColor: ThemeSettings.primaryColor,
      primaryColorDark: ThemeSettings.darkColor,
      primaryColorLight: ThemeSettings.grayColor,
      accentColor: ThemeSettings.accentColor,
      fontFamily: 'Ubuntu',
      textTheme: TextTheme(
        bodyText2: TextStyle(color: ThemeSettings.darkColor, fontSize: 16),
      ),
      iconTheme: IconThemeData(
        color: ThemeSettings.primaryColor,
      ),
      buttonTheme: ButtonThemeData(
        height: 45,
        minWidth: 200,
        buttonColor: ThemeSettings.accentColor,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: ThemeSettings.accentColor,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: ThemeSettings.lightColor,
      appBarTheme: AppBarTheme(
          elevation: 0,
          color: ThemeSettings.lightColor,
          centerTitle: true,
          iconTheme: IconThemeData(color: ThemeSettings.primaryColor),
          textTheme: TextTheme(
            headline6: TextStyle(
              color: ThemeSettings.textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat'
            ),
          )),
    );

class ThemeSettings {
  static double getMainPadding() => 8;
  static final primaryColor = Color(0xFFE8C1AC);
  static final accentColor = Color(0xFF4F152E);
  static final textColor = Color(0xFF6E1B35);
  static final darkColor = Color(0xFF000000);
  static final lightColor = Color(0xFFffffff);
  static final grayColor = Color(0xFFf9f9f9);
}
