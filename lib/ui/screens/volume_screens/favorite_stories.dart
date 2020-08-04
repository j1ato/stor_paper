import 'package:flutter/material.dart';
import 'package:stor_paper/model/database_models.dart';
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

  @override
  Widget build(BuildContext context) {
    final userFavorites = Provider.of<UserFavorites>(context);
    final volumes = Provider.of<List<Volume>>(context);

    Widget _buildStories() {
      final List<StoriesCard> storyCards = [];
      Widget returnedWidget;

      for (final volume in volumes) {
        for (final Map singleStory in volume.stories) {
          try {
            if (userFavorites.favorites.contains(singleStory['id'])) {
              storyCards.add(StoriesCard(
                stories: singleStory,
              ));
            }
          } on Exception catch (e) {
            print(e);
          }
          if (storyCards.isEmpty) {
            returnedWidget = Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.favorite,
                size: 200,
                color: Colors.white.withOpacity(0.06),
              ),
            );
          } else {
            returnedWidget = Padding(
              padding: const EdgeInsets.only(top: 10),
              child: AnimationLimiter(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  key: const PageStorageKey(1),
                  cacheExtent: 3000,
                  itemCount: storyCards.length,
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 20,
                  ),
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50,
                        child: FadeInAnimation(
                          child: storyCards[index],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }
        }
      }
      return returnedWidget;
    }

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(child: _buildStories()),
          ],
        ),
        //     body: _buildStories()),
      ),
    );
  }
}
