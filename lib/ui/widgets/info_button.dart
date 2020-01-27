import 'package:flutter/material.dart';

import '../theme.dart';

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
      bottom: type == 'story card' ? 1 : pageHeight * 0.005,
      right: type == 'story card' ? 1 : pageWidth * 0.02,
      child: RawMaterialButton(
        constraints: const BoxConstraints(minWidth: 25, minHeight: 25),
        onPressed: () => showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            elevation: 50,
            backgroundColor: const Color(0xF0111114).withOpacity(0.8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Center(
                  child: Text(
                title,
                style: buildTheme().textTheme.subtitle,
              )),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: pageHeight * 0.06,
                  width: pageWidth * 0.94,
                  child: Text(
                    info,
                    style: buildTheme().textTheme.body2,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
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
              ),
            ],
          ),
        ),
        child: Icon(
          Icons.more_vert,
          size: 20,
          color: Colors.white.withOpacity(0.7),
        ),
        elevation: 0,
        fillColor: Colors.black.withOpacity(0.06),
        shape: const CircleBorder(),
      ),
    );
  }
}
