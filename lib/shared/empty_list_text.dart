import 'package:flutter/material.dart';
import 'package:moveness/app_theme.dart';

class EmptyListText extends StatelessWidget {
  EmptyListText(this._text);

  final String _text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(ThemeSettings.getMainPadding()),
        child: Text(
            _text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ThemeSettings.darkColor,
            fontFamily: 'Montserrat',
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w500,
            fontSize: 14
          ),
        ),
      ),
    );
  }
}
