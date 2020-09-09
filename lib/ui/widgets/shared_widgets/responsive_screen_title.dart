import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stor_paper/providers/controller_states.dart';

import '../../theme.dart';

class ResponsiveScreenTitle extends StatelessWidget {
  const ResponsiveScreenTitle(
      {Key key, this.scrollState, this.title, this.type})
      : super(key: key);

  final StoriesScreenState scrollState;
  final String title;
  final String type;

  @override
  Widget build(BuildContext context) {
    var favoritesScreenOffset =
        Provider.of<StoriesScreenState>(context).favoritesScreenOffset;
    var volumeStoriesOffset =
        Provider.of<StoriesScreenState>(context).volumeStoriesOffset;


    return Positioned.fill(
      top: type == 'FS'
          ? 55 - favoritesScreenOffset * 0.8
          : 55 - volumeStoriesOffset * 0.8,
      child: Align(
        alignment: Alignment.topCenter,
        child: Text(
          title,
          style: buildTheme().textTheme.headline1,
        ),
      ),
    );
  }
}
