import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OkDialog extends StatelessWidget {
  final String content;
  final String title;
  final String buttonText;

  OkDialog({
    required this.title,
    required this.buttonText,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    if (!Platform.isIOS) {
      return AlertDialog(
        title: new Text(
          title,
        ),
        content: new Text(
          this.content,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              buttonText,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      );
    } else {
      return CupertinoAlertDialog(
          title: Text(
            title,
          ),
          content: Text(
            this.content,
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(buttonText),
              onPressed: () => Navigator.of(context).pop(),
            )
          ]);
    }
  }
}
