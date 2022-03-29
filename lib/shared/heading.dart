import 'package:flutter/material.dart';

class Heading extends StatelessWidget {
  Heading(this._text, this._color);

  final String _text;
  final Color _color;

  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: _color,
        fontFamily: 'Montserrat',
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
