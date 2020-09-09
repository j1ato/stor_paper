import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:stor_paper/providers/all_shared_prefs.dart';
import 'package:stor_paper/providers/controller_states.dart';
import 'package:stor_paper/providers/database_services.dart';
import 'package:stor_paper/model/database_models.dart';
import 'package:stor_paper/ui/widgets/shared_widgets/responsive_screen_title.dart';
import 'package:stor_paper/ui/widgets/story_widgets/close_button.dart';
import 'package:stor_paper/ui/widgets/story_widgets/stories_card.dart';
import 'package:stor_paper/ui/theme.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:stor_paper/providers/user_repository.dart';

// builds an animated listview of custom containers
// that represent individual stories and wallpapers

class StoriesScreen extends StatelessWidget {
  StoriesScreen({Key key, this.stories, this.volumeTitle}) : super(key: key);

  final List<Map> stories;
  final String volumeTitle;

  static String id = 'storiesScreen';

  
  @override
  Widget build(BuildContext context) {
    print('stories screen just rebuilt itself');
    ScrollController _scrollController = ScrollController();
    Provider.of<StoriesScreenState>(context, listen: false).initialVolumeStoriesScrollState(0);

    Widget _buildStories() {
      Key storyCardListKey = UniqueKey();
      Widget storyCardList = SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return StoriesCard(
            // scrollController: _scrollController,
            stories: stories[index],
            context: context,
          );
        }, childCount: stories.length),
        key: storyCardListKey,
      );

      return Scrollable(
        key: PageStorageKey(UniqueKey()),
        controller: _scrollController,
        viewportBuilder: (BuildContext context, ViewportOffset offset) {
          Provider.of<StoriesScreenState>(context, listen: false)
              .updateVolumeStoriesScreenState(_scrollController);
          return Viewport(
            offset: offset,
            anchor: 0.2,
            center: storyCardListKey,
            slivers: [
              storyCardList,
            ],
          );
        },
      );

      //  AnimationLimiter(
      //   child: ListView.separated(
      //     controller: _scrollController,
      //     cacheExtent: 3000,
      //     physics: const BouncingScrollPhysics(
      //         parent: AlwaysScrollableScrollPhysics()),
      //     key: const PageStorageKey(1),
      //     itemCount: stories.length,
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
      //             child: StoriesCard(
      //               scrollController: _scrollController,
      //               stories: stories[index],
      //               context: context,
      //             ),
      //           ),
      //         ),
      //       );
      //     },
      //   ),
      // );
    }

    return 
    
    // StreamProvider<UserFavorites>.value(
    //   value: db.streamFavorites(currentUser),
    //   catchError: (context, error) {
    //     print('this is the user favorites'
    //         ' stream error ${error.toString()}');
    //     return UserFavorites.fromFirestore({
    //       'favorites': ['']
    //     });
    //   },
    //   child:
       Scaffold(
        body: Stack(
          children: <Widget>[
            ResponsiveScreenTitle(
              key: UniqueKey(),
              title: volumeTitle,
              type: 'VS',
            ),
            _buildStories(),
            PageCloseButton(
              onTap: () {
                Navigator.pop(context);
                print('tapped');
              },
            ),
          ],
        ),
        // ),
      );
    // );
  }
}
