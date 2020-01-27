import 'package:flutter/material.dart';
import 'package:stor_paper/ui/widgets/stories_card.dart';
import 'package:stor_paper/ui/theme.dart';
import 'package:stor_paper/utils/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// builds an animated listview of custom containers 
// that represent individual stories and wallpapers
 

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({Key key, this.stories, this.volumeTitle, this.artworks})
      : super(key: key);

  static String id = 'storyChooser';

  final List<Map> stories;
  final Map artworks;
  final String volumeTitle;

  static final UserRepository user = UserRepository.instance();

  @override
  _StoriesScreenState createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  final ScrollController _scrollController = ScrollController();
  final CollectionReference collectionReference =
      Firestore.instance.collection('users');

  Stream<QuerySnapshot> streamSnapshots;

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
            itemCount: widget.stories.length,
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
                      stories: widget.stories[index],
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
                  widget.volumeTitle,
                  style: buildTheme().textTheme.display1,
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
