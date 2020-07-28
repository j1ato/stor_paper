import 'package:flutter/material.dart';

import '../theme.dart';

// displays translations as a listview within dialog

class GlossaryTexts extends StatelessWidget {
  const GlossaryTexts({this.glossaryItems});

  final List<dynamic> glossaryItems;

  @override
  Widget build(BuildContext context) {
    final List<Widget> textElements = [];

    for (final String glossaryTextString in glossaryItems) {
      textElements.add(
          Text(glossaryTextString, style: buildTheme().textTheme.bodyText1));
      textElements.add(
        const SizedBox(
          height: 20,
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(25, 25, 25, 75),
      children: textElements,
    );
  }
}
