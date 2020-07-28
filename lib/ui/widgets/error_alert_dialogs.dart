import 'package:flutter/material.dart';

import '../theme.dart';

// alert dialog that is used to show errors during
// sign up and sign in attempts

class ErrorAlertDialog extends StatelessWidget {
  const ErrorAlertDialog({this.errorMessage});
  final String errorMessage;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        child: Text(
          errorMessage,
          style: buildTheme().textTheme.bodyText2,
        ),
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.close,
            size: 20,
            color: Colors.white.withOpacity(0.6),
          ),
        )
      ],
    );
  }
}
