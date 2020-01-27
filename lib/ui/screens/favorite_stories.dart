import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:stor_paper/ui/widgets/stories_card.dart';
import 'package:stor_paper/utils/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// Connects to story ids located within a volume in firebase and compares 
// them to story ids within the users favorited list of stories
// if the list of favorites contains the story id then that particular story 
//shows up

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key key}) : super(key: key);
  static String id = 'favoriteStories';

  @override
  Widget build(BuildContext context) {
    final userRepository = Provider.of<UserRepository>(context);
    List<dynamic> stories;
    Map singleStoryMap;
    Widget storyCardWidget;

    final Stream _userFavorites = Firestore.instance
        .collection('users')
        .document(userRepository.user.uid)
        .snapshots();

    StreamBuilder _buildStories({List<String> ids}) {
      final CollectionReference collectionReference =
          Firestore.instance.collection('Volumes');

      final Stream<QuerySnapshot> streamSnapshots =
          collectionReference.snapshots();

      return StreamBuilder<QuerySnapshot>(
        stream: streamSnapshots,
        builder: (context, volumeSnapshot) {
          if (!volumeSnapshot.hasData) {
            return Center(
              child: SpinKitPulse(
                size: 150,
                color: Colors.white.withOpacity(0.6),
              ),
            );
          } else {
            return StreamBuilder(
              stream: _userFavorites,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final volumes = volumeSnapshot.data.documents;

                  final List<StoriesCard> storyCard = [];

                  for (final volume in volumes) {
                    stories = volume.data['stories'];
                    for (final Map story in stories) {
                      try {
                        if (snapshot.data['favorites'].contains(story['id'])) {
                          singleStoryMap = story;
                          storyCardWidget = StoriesCard(
                            stories: singleStoryMap,
                          );

                          storyCard.add(storyCardWidget);
                        }
                      } on Exception catch (e) {
                        print(e);
                      }
                    }
                  }

                  if (storyCard.isEmpty) {
                    return Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.favorite,
                        size: 200,
                        color: Colors.white.withOpacity(0.06),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: AnimationLimiter(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          key: const PageStorageKey(1),
                          cacheExtent: 3000,
                          itemCount: storyCard.length,
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 20,
                          ),
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                verticalOffset: 50,
                                child: FadeInAnimation(
                                  child: storyCard[index],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }
                } else {
                  return Center(
                    child: SpinKitPulse(
                      size: 150,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  );
                }
              },
            );
          }
        },
      );
    }

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(child: _buildStories()),
          ],
        ),
        //     body: _buildStories()),
      ),
    );
  }
}
