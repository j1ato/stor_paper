import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:stor_paper/providers/controller_states.dart';
import 'package:stor_paper/ui/widgets/shared_widgets/responsive_screen_title.dart';
import 'package:stor_paper/ui/widgets/story_widgets/close_button.dart';
import 'package:stor_paper/ui/widgets/story_widgets/stories_card.dart';

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
    Provider.of<StoriesScreenState>(context, listen: false)
        .initialVolumeStoriesScrollState(0);

    Widget _buildStories() {
      Key storyCardListKey = UniqueKey();
      Widget storyCardList = SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return StoryCard(
            story: stories[index],
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
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          ResponsiveTitle(
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
