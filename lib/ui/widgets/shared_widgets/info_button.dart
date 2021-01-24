import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme.dart';

// shows a dialog of volume and story information when pressed
// such as the title and a short blurb

class InfoButton extends StatelessWidget {
  const InfoButton(
      {this.context, this.title, this.info, this.type, this.onPressed});

  final Function onPressed;
  final BuildContext context;
  final String title;
  final String info;
  final String type;

  @override
  Widget build(BuildContext context) {
    final pageHeight = MediaQuery.of(context).size.height;
    final pageWidth = MediaQuery.of(context).size.width;

    return Positioned(
      bottom: type == 'story card' ? 5 : pageHeight * 0.01,
      right: type == 'story card' ? 10 : pageWidth * 0.02,
      child: RawMaterialButton(
        constraints: const BoxConstraints(minWidth: 25, minHeight: 25),
        onPressed: onPressed,
        child: Icon(
          Icons.more_vert,
          size: 12,
          color: Colors.white.withOpacity(0.7),
        ),
        elevation: 0,
        fillColor: Colors.black87.withOpacity(0.8),
        shape: const CircleBorder(),
      ),
    );
  }
}
