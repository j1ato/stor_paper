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
import '../shared_widgets/info_button.dart';

// custom container that displays stories as a card
// user can expand to view artwork, favorite the story
// find out more info or tap to read the story

class StoriesCard extends StatelessWidget {
  const StoriesCard({
    Key key,
    this.stories,
    this.imageURL,
    this.inFavorites,
    this.onFavoriteButtonPressed,
    this.scrollController,
    this.context,
  }) : super(key: key);

  final Map stories;
  final Future imageURL;
  final bool inFavorites;
  final Function onFavoriteButtonPressed;
  final ScrollController scrollController;
  final BuildContext context;

  @override
  Widget build(BuildContext buildContext) {
    final pageHeight = MediaQuery.of(buildContext).size.height;
    final pageWidth = MediaQuery.of(buildContext).size.width;
    var db = DatabaseServices();
    final FirebaseUser currentUser = Provider.of<UserRepository>(context).user;

    return CachedNetworkImage(
      placeholderFadeInDuration: const Duration(milliseconds: 500),
      placeholder: (context, holder) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: Center(
            child: Container(
              height: pageHeight * 0.52,
              width: pageWidth * 0.9,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: const BorderRadius.all(Radius.circular(0)),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 12, color: Colors.blueGrey.withOpacity(0.5))
                ],
              ),
            ),
          ),
        );
      },
      imageUrl: stories['image'],
      imageBuilder: (context, imageProvider) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 65),
          child: Stack(
            children: <Widget>[
              Hero(
                tag: stories['id'],
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: pageHeight * 0.52,
                    width: pageWidth * 0.9,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueGrey.withOpacity(0.2),
                          blurRadius: 5,
                          offset: Offset(2, 2),
                        )
                      ],
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25),
                        splashColor: Colors.white.withOpacity(0.03),
                        highlightColor: Colors.black.withOpacity(0.03),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReadStory(
                                key: const PageStorageKey('ReadStory'),
                                stories: stories,
                                inFavorites: inFavorites,
                                onFavoriteButtonPressed:
                                    onFavoriteButtonPressed,
                              ),
                            ),
                          );
                        },
                      ),
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
                child: 
                FavoriteButton(
                  storyID: stories['id'],
                ),
              ),
              StoryExpandButton(
                storyID: stories['id'],
                imageURL: stories['image'],
              ),
              InfoButton(
                type: 'story card',
                title: stories['storyTitle'],
                info: stories['blurb'],
              ),
            ],
          ),
        );
      },
    );
  }
}
