import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:stor_paper/model/database_models.dart';
import 'package:stor_paper/providers/controller_states.dart';
import 'package:stor_paper/ui/widgets/story_widgets/stories_card.dart';

class FavoritesStoriesBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final UserFavorites userFavorites = Provider.of<UserFavorites>(context);
    final List<Volume> volumes = Provider.of<List<Volume>>(context);

    final ScrollController _controller = ScrollController();

    Provider.of<StoriesScreenState>(context, listen: false)
        .updateFavoriteStoriesScreenState(_controller);

    List<StoryCard> storyCards = [];

    Widget storyList;

    Key storyCardListKey = UniqueKey();

    for (final Volume volume in volumes) {
      for (final Map story in volume.stories) {
        if (userFavorites.favorites.contains(story['id'])) {
          storyCards.add(StoryCard(
            story: story,
            context: context,
          ));
        }
      }
    }

    storyCards.isEmpty
        ? storyList = Align(
            alignment: Alignment.center,
            child: Icon(
              Icons.favorite,
              size: 200,
              color: Colors.white.withOpacity(0.06),
            ),
          )
        : storyList = Scrollable(
            controller: _controller,
            viewportBuilder: (BuildContext context, ViewportOffset offset) {
              return Viewport(
                offset: offset,
                anchor: 0.2,
                center: storyCardListKey,
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return storyCards[index];
                      },
                      childCount: storyCards.length,
                    ),
                    key: storyCardListKey,
                  ),
                ],
              );
            },
          );

    return storyList;
  }
}
