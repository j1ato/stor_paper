import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stor_paper/model/database_models.dart';
import 'package:stor_paper/providers/firestore.dart';
import 'package:stor_paper/providers/user_repository.dart';

class ReadScreenFavoriteButton extends StatelessWidget {
  const ReadScreenFavoriteButton({
    @required this.storyID,
  });

  final String storyID;

      void _handleFavoriteStoriesChanged(String storyID, UserRepository userRepository) {
        UserFavourites favorites = UserFavourites();
        favorites.updateFavorites(userRepository.user.uid, storyID);
    }


  @override
  Widget build(BuildContext context) {
    final UserRepository user = Provider.of<UserRepository>(context);
    final Stream _userFavorites = Firestore.instance
        .collection('users')
        .document(user.user.uid)
        .snapshots();

    return StreamBuilder(
      stream: _userFavorites,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            height: 55,
            width: 55,
            child: FittedBox(
              child: FloatingActionButton(
                // constraints: BoxConstraints.tight(Size(40, 40)),
                onPressed: () {
                  try {
                    _handleFavoriteStoriesChanged(storyID, user);
                  } on Exception catch (e) {
                    print(e);
                  }
                },
                child: Icon(
                  snapshot.data['favorites'].contains(storyID) == true
                      ? Icons.favorite
                      : Icons.favorite_border,
                  size: 18,
                  color: Colors.white.withOpacity(0.6),
                ),

                elevation: 0,
                backgroundColor: const Color(0xF0111114).withOpacity(0.8),
                shape: const CircleBorder(),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

