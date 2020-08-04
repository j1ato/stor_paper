import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:stor_paper/ui/theme.dart';

// flushbars that indicate there is no internet connectivity
// or that download has completed or has begun

class Flushbars {
  Flushbar connetivityFlushbar (BuildContext context) {
    return Flushbar(
      messageText: Text(
          'Something went wrong,'
          ' please check your network'
          ' connection.',
          style: buildTheme().textTheme.caption),
      backgroundColor: Colors.black.withOpacity(0.6),
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: const EdgeInsets.all(8),
      borderRadius: 5,
      duration: const Duration(seconds: 3),
    )..show(context);
  }
    Flushbar downloadStatusFlushbar (BuildContext context, String text) {
    return Flushbar(
            backgroundColor: Colors.black.withOpacity(0.6),
            flushbarStyle: FlushbarStyle.FLOATING,
            margin: const EdgeInsets.all(8),
            borderRadius: 2,
            messageText: Text(
              text,
              style: buildTheme().textTheme.caption,
            ),
            duration: const Duration(seconds: 3),
          )..show(context);
  }

}
