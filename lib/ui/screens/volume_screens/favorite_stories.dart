import 'package:flutter/material.dart';
import 'package:stor_paper/ui/widgets/shared_widgets/responsive_screen_title.dart';
import 'package:stor_paper/ui/widgets/story_widgets/favorite_stories_builder.dart';

// Connects to story ids located within a volume in firebase and compares
// them to story ids within the users favorited list of stories
// if the list of favorites contains the story id then that particular story
//shows up

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key key}) : super(key: key);
  static String id = 'favoriteStories';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: FavoritesStoriesBuilder(),
          ),
          ResponsiveTitle(
            key: UniqueKey(),
            title: 'SII\'s',
            type: 'FS',
          )
        ],
      ),
      //     body: _buildStories()),
    );
  }
}
