import 'package:flutter/material.dart';
import 'package:stor_paper/ui/screens/read_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stor_paper/ui/widgets/story_expand_button.dart';
import 'package:stor_paper/ui/widgets/story_favorite_button.dart';
import 'info_button.dart';

// custom container that displays stories as a card
// user can expand to view artwork, favorite the story
// find out more info or tap to read the story
 
class StoriesCard extends StatefulWidget {
  const StoriesCard({
    this.stories,
    this.imageURL,
    this.inFavorites,
    this.onFavoriteButtonPressed,
    this.scrollController,
    this.context,
  });

  final Map stories;
  final Future imageURL;
  final bool inFavorites;
  final Function onFavoriteButtonPressed;
  final ScrollController scrollController;
  final BuildContext context;

  @override
  _StoriesCardState createState() => _StoriesCardState();
}

class _StoriesCardState extends State<StoriesCard> {
  @override
  Widget build(BuildContext buildContext) {
    final pageHeight = MediaQuery.of(buildContext).size.height;
    final pageWidth = MediaQuery.of(buildContext).size.width;

    return CachedNetworkImage(
      placeholderFadeInDuration: const Duration(milliseconds: 500),
      placeholder: (context, holder) {
        return Container(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: pageHeight * 0.59,
                  width: pageWidth * 0.95,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(Radius.circular(2)),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 5, color: Colors.black.withOpacity(0.5))
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      imageUrl: widget.stories['image'],
      imageBuilder: (context, imageProvider) {
        return Container(
          child: Center(
            child: Stack(
              children: <Widget>[
                Hero(
                  tag: widget.stories['id'],
                  child: Container(
                    height: pageHeight * 0.59,
                    width: pageWidth * 0.96,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(3),
                        splashColor: Colors.white.withOpacity(0.2),
                        highlightColor: Colors.black.withOpacity(0.7),
                        onTap: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReadStory(
                                key: const PageStorageKey('ReadStory'),
                                stories: widget.stories,
                                inFavorites: widget.inFavorites,
                                onFavoriteButtonPressed:
                                    widget.onFavoriteButtonPressed,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: pageWidth * 0.42,
                  bottom: 1,
                  child: FavoriteButton(
                    storyID: widget.stories['id'],
                  ),
                ),
                Positioned(
                  left: 1,
                  bottom: 1,
                  child: StoryExpandButton(
                    storyID: widget.stories['id'],
                    imageURL: widget.stories['image'],
                  ),
                ),
                InfoButton(
                  type: 'story card',
                  title: widget.stories['storyTitle'],
                  info: widget.stories['blurb'],
                ),
              ],
            ),

          ),
        );
      },
    );
  }
}

