import 'package:flutter/material.dart';
import 'package:stor_paper/ui/theme.dart';

// card used for settings button on settings screen

class SettingsCard extends StatelessWidget {
  const SettingsCard({@required this.text, @required this.onPressed});

  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    Padding _buildTitleSection() {
      return Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              text,
              style: buildTheme().textTheme.button,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
        ),
        color: const Color(0xF0111114).withOpacity(0.8),
        elevation: 3,
        child: InkWell(
          onTap: onPressed,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildTitleSection(),
            ],
          ),
        ),
      ),
    );
  }
}
