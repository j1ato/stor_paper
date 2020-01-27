import 'package:flutter/material.dart';
import 'package:stor_paper/ui/widgets/story_paragraphs_list.dart';

class ReadStory extends StatelessWidget {
  const ReadStory(
      {Key key,
      this.stories,
      this.imageURL,
      this.inFavorites,
      this.onFavoriteButtonPressed})
      : super(key: key);

  static String id = 'readStory';

  final Map stories;
  final String imageURL;
  final Function onFavoriteButtonPressed;
  final bool inFavorites;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StoryParagraphs(
        stories: stories,
        storyParagraphs: stories['paragraphs'],
      ),
    );
  }
}
