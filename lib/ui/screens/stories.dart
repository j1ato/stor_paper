import 'package:flutter/material.dart';
import 'package:stor_paper/ui/widgets/stories_card.dart';
import 'package:stor_paper/ui/theme.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// builds an animated listview of custom containers 
// that represent individual stories and wallpapers
 

class StoriesScreen extends StatelessWidget {
    StoriesScreen({
    Key key,
    this.stories,
    this.volumeTitle
  }): super(key: key);

  final List<Map > stories;
  final String volumeTitle;

  static String id = 'storiesScreen';

  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    Padding _buildStories() {
      return Padding(
        padding: const EdgeInsets.only(top: 20),
        child: AnimationLimiter(
          child: ListView.separated(
            cacheExtent: 3000,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            key: const PageStorageKey(1),
            itemCount: stories.length,
            separatorBuilder: (context, index) => const SizedBox(
              height: 30,
            ),
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50,
                  child: FadeInAnimation(
                    child: StoriesCard(
                      scrollController: _scrollController,
                      stories: stories[index],
                      context: context,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, scrollView) {
            return [
              SliverAppBar(
                leading: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    size: 25,
                  ),
                ),
                expandedHeight: 50,
                title: Text(
                  volumeTitle,
                  style: buildTheme().textTheme.headline1,
                ),
                centerTitle: true,
              )
            ];
          },
          body: _buildStories(),
        ),
      ),
    );
  }
}
