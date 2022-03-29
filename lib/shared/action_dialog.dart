import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActionDialog extends StatelessWidget {
  ActionDialog({
    required this.title,
    required this.content,
    required this.positive,
    required this.positiveText,
  });

  final String content;
  final String title;
  final String positiveText;
  final Function() positive;

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS) {
      return AlertDialog(
        title: new Text(title),
        content: new Text(this.content),
        actions: <Widget>[
          FlatButton(
            child: Text('Avbryt'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FlatButton(
            child: Text(positiveText),
            onPressed: () {
              positive();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    } else {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(this.content),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Avbryt'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            child: Text(positiveText),
            onPressed: () {
              positive();
              Navigator.of(context).pop();
            },
          )
        ],
      );
    }
  }
}
