import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:stor_paper/model/database_models.dart';
import 'package:stor_paper/providers/controller_states.dart';
import 'package:stor_paper/ui/widgets/story_widgets/stories_card.dart';

class FavoritesStoriesBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userFavorites = Provider.of<UserFavorites>(context);
    final volumes = Provider.of<List<Volume>>(context);
    final ScrollController _controller = ScrollController();
    
    Provider.of<StoriesScreenState>(context, listen: false)
        .updateFavoriteStoriesScreenState(_controller);
    List<StoriesCard> storyCards = [];
    Widget returnedStoriesList;
    Key storyCardListKey = UniqueKey();


    // var interesting = volumes.for (var volume in volumes) {

    // }

    // where((volume) => volume.stories.where((story) => userFavorites.favorites.contains(story['id'])) == true)

    // map((volume) => volume.stories.where((story) => userFavorites.favorites.contains(story['id'])).map((favoritedStory) => StoriesCard(
    //   stories: favoritedStory
    // ))).toList();

    //     .map((story) => Story.fromFirestore(story).id)
    //     .forEach((element) {
    //   allStoryIds.add(element);
    //   print(allStoryIds);
    // })
    // .where((id) => userFavorites.favorites.contains(id))

    //     forEach((id) {
    //   print('all ids are here $id');
    //   String storyId;
    //   if (userFavorites.favorites.contains(id)) {
    //     storyId = id;
    //   }
    //   return storyId;
    // })

    // );

    // print('matched ids $interesting');

    // userFavorites.favorites.where((element) =>
    //     element ==
    //     volumes.map((volume) => volume.stories.map((story) => story['id'])));

    for (final Volume volume in volumes) {
      // List<StoriesCard> storiesList = volume.stories
      //     .where((story) => userFavorites.favorites.contains(story['id']))
      //     .map((favoritedStory) => StoriesCard(stories: favoritedStory))
      //     .toList();

      //     print('this is the list of stories: $storiesList');

      // if (storiesList.isEmpty) {
      //   returnedStoriesList = Align(
      //     alignment: Alignment.center,
      //     child: Icon(
      //       Icons.favorite,
      //       size: 200,
      //       color: Colors.white.withOpacity(0.06),
      //     ),
      //   );
      // } else {
      // returnedStoriesList = Scrollable(
      //   controller: _controller,
      //   viewportBuilder: (BuildContext context, ViewportOffset offset) {
      //     return Viewport(
      //       offset: offset,
      //       anchor: 0.15,
      //       center: storyCardListKey,
      //       slivers: [
      //         SliverList(
      //           delegate: SliverChildBuilderDelegate(
      //               (BuildContext context, int index) {
      //             return storiesList[index];
      //           }, childCount: userFavorites.favorites.length),
      //           key: storyCardListKey,
      //         ),
      //       ],
      //     );
      //   },
      // );

      // AnimationLimiter(
      //   child: ListView.separated(
      //     controller: controller,
      //     physics: const BouncingScrollPhysics(
      //         parent: AlwaysScrollableScrollPhysics()),
      //     key: const PageStorageKey(1),
      //     cacheExtent: 3000,
      //     itemCount: storyCards.length,
      //     separatorBuilder: (context, index) => const SizedBox(
      //       height: 20,
      //     ),
      //     itemBuilder: (context, index) {
      //       return AnimationConfiguration.staggeredList(
      //         position: index,
      //         duration: const Duration(milliseconds: 375),
      //         child: SlideAnimation(
      //           verticalOffset: 50,
      //           child: FadeInAnimation(
      //             child: storyCards[index],
      //           ),
      //         ),
      //       );
      //     },
      //   ),
      // );
      // }

      for (final Map singleStory in volume.stories) {
        try {
          if (userFavorites.favorites.contains(singleStory['id'])) {

            storyCards.add(StoriesCard(
              stories: singleStory,
              context: context,
            ));
          }
        } on Exception catch (e) {
          print(e);
        }
        if (storyCards.isEmpty) {
          returnedStoriesList = Align(
            alignment: Alignment.center,
            child: Icon(
              Icons.favorite,
              size: 200,
              color: Colors.white.withOpacity(0.06),
            ),
          );
        } else {
          returnedStoriesList = Scrollable(
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
                      // userFavorites.favorites.length
                    ),
                    key: storyCardListKey,
                  ),
                ],
              );
            },
          );

          //     // AnimationLimiter(
          //     //   child: ListView.separated(
          //     //     controller: controller,
          //     //     physics: const BouncingScrollPhysics(
          //     //         parent: AlwaysScrollableScrollPhysics()),
          //     //     key: const PageStorageKey(1),
          //     //     cacheExtent: 3000,
          //     //     itemCount: storyCards.length,
          //     //     separatorBuilder: (context, index) => const SizedBox(
          //     //       height: 20,
          //     //     ),
          //     //     itemBuilder: (context, index) {
          //     //       return AnimationConfiguration.staggeredList(
          //     //         position: index,
          //     //         duration: const Duration(milliseconds: 375),
          //     //         child: SlideAnimation(
          //     //           verticalOffset: 50,
          //     //           child: FadeInAnimation(
          //     //             child: storyCards[index],
          //     //           ),
          //     //         ),
          //     //       );
          //     //     },
          //     //   ),
          //     // );
          //   }
          // }
        }
      }
    }
    return returnedStoriesList;
  }
}
