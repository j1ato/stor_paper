import 'package:flutter/material.dart';
import '../story_widgets/glossary.dart';

// alert dialog that will contain a list of translations from
// the short stories as some words will be in native
// african language

class GlossaryAlertDialog extends StatelessWidget {
  const GlossaryAlertDialog({Key key, this.glossaryItems, })
      : super(key: key);
  final List<dynamic> glossaryItems;

    @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Container(
          height: 300,
          width: 350,
          child: GlossaryTexts(
            glossaryItems: glossaryItems,
          ),
        ),
      ]),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.close,
            size: 20,
            color: Colors.white.withOpacity(0.6),
          ),
        )
      ],
    );
  }
}

