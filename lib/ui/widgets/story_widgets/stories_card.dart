import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stor_paper/model/database_models.dart';
import 'package:stor_paper/providers/database_services.dart';
import 'package:stor_paper/providers/user_repository.dart';
import 'package:stor_paper/ui/screens/volume_screens/read_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:stor_paper/ui/widgets/story_widgets/story_expand_button.dart';
import 'package:stor_paper/ui/widgets/story_widgets/story_favorite_button.dart';
import '../../theme.dart';
import '../shared_widgets/info_button.dart';

// custom container that displays stories as a card
// user can expand to view artwork, favorite the story
// find out more info or tap to read the story

class StoryCard extends StatefulWidget {
  const StoryCard({
    Key key,
    this.story,
    this.imageURL,
    this.inFavorites,
    this.onFavoriteButtonPressed,
    this.scrollController,
    this.context,
  }) : super(key: key);

  final Map story;
  final Future imageURL;
  final bool inFavorites;
  final Function onFavoriteButtonPressed;
  final ScrollController scrollController;
  final BuildContext context;

  @override
  _StoryCardState createState() => _StoryCardState();
}

class _StoryCardState extends State<StoryCard> {
  double opacityLevel = 0.0;

  void _changeOpacity() {
    setState(() {
      opacityLevel = opacityLevel == 0 ? 1.0 : 0.0;
    });
  }

  @override
  Widget build(BuildContext buildContext) {
    final pageHeight = MediaQuery.of(buildContext).size.height;
    final pageWidth = MediaQuery.of(buildContext).size.width;
    var db = DatabaseServices();
    final FirebaseUser currentUser =
        Provider.of<UserRepository>(widget.context).user;

    return CachedNetworkImage(
      placeholderFadeInDuration: const Duration(milliseconds: 500),
      placeholder: (context, holder) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 65),
          child: Center(
            child: Container(
              height: pageHeight * 0.53,
              width: pageWidth * 0.9,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 12, color: Colors.blueGrey.withOpacity(0.5))
                ],
              ),
            ),
          ),
        );
      },
      imageUrl: widget.story['image'],
      imageBuilder: (context, imageProvider) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 65),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReadStory(
                    key: const PageStorageKey('ReadStory'),
                    stories: widget.story,
                    inFavorites: widget.inFavorites,
                    onFavoriteButtonPressed: widget.onFavoriteButtonPressed,
                  ),
                ),
              );
            },
            child: Hero(
              tag: widget.story['id'],
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  height: pageHeight * 0.53,
                  width: pageWidth * 0.9,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey.withOpacity(0.2),
                        blurRadius: 8,
                        offset: Offset(2, 2),
                      )
                    ],
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      AnimatedOpacity(
                        curve: Curves.linear,
                        opacity: opacityLevel,
                        duration: Duration(milliseconds: 500),
                        child: Container(
                          height: pageHeight * 0.53,
                          width: pageWidth * 0.9,
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueGrey.withOpacity(0.6),
                              )
                            ],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30)),
                          ),
                        ),
                      ),
                      Center(
                        child: AnimatedOpacity(
                          curve: Curves.linear,
                          opacity: opacityLevel,
                          duration: Duration(
                              milliseconds: opacityLevel == 0 ? 500 : 800),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(widget.story['storyTitle'],
                                    style: buildTheme().textTheme.subtitle1),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(widget.story['blurb'],
                                    style: buildTheme().textTheme.bodyText2),
                              ],
                            ),
                          ),
                        ),
                      ),
                      StreamProvider<UserFavorites>.value(
                        value: db.streamFavorites(currentUser),
                        catchError: (context, error) {
                          print('this is the user favorites'
                              ' stream error ${error.toString()}');
                          return UserFavorites.fromFirestore({
                            'favorites': ['']
                          });
                        },
                        child: FavoriteButton(
                          storyID: widget.story['id'],
                        ),
                      ),
                      StoryExpandButton(
                        storyID: widget.story['id'],
                        imageURL: widget.story['image'],
                      ),
                      InfoButton(
                        type: 'story card',
                        title: widget.story['storyTitle'],
                        info: widget.story['blurb'],
                        onPressed: () => _changeOpacity(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
