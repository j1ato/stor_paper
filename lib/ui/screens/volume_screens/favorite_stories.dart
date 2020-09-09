import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stor_paper/model/database_models.dart';
import 'package:stor_paper/providers/controller_states.dart';
import 'package:stor_paper/ui/theme.dart';
import 'package:stor_paper/ui/widgets/shared_widgets/responsive_screen_title.dart';
import 'package:stor_paper/ui/widgets/story_widgets/favorite_stories_builder.dart';
import 'package:stor_paper/ui/widgets/story_widgets/stories_card.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// Connects to story ids located within a volume in firebase and compares
// them to story ids within the users favorited list of stories
// if the list of favorites contains the story id then that particular story
//shows up

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key key}) : super(key: key);
  static String id = 'favoriteStories';

//   @override
//   _FavoritesScreenState createState() => _FavoritesScreenState();
// }

// class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: FavoritesStoriesBuilder(),
          ),
          ResponsiveScreenTitle(
            key: UniqueKey(),
            title: 'SII\'s',
            type: 'FS',
          )
        ],
      ),
      //     body: _buildStories()),
    );
    // );
  }
}
