import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stor_paper/model/database_models.dart';
import 'package:stor_paper/providers/firestore.dart';
import 'package:stor_paper/providers/user_repository.dart';

import '../popup_dialogs/flushbars.dart';

// when tapped it updates list of favorites and is
// either an outline or filled in depending

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    @required this.storyID,
  });

  final String storyID;

      void _handleFavoriteStoriesChanged(String storyID, UserRepository userRepository) {
        UserFavourites favorites = UserFavourites();
        favorites.updateFavorites(userRepository.user.uid, storyID);
    }

  @override
  Widget build(BuildContext context) {
    final userRepository = Provider.of<UserRepository>(context);
    final userFavorites = Provider.of<UserFavorites>(context);


    final Stream _userDocument = Firestore.instance
        .collection('users')
        .document(userRepository.user.uid)
        .snapshots();

    return Positioned.fill(
      bottom: 5,
          child: Align(
        alignment: AlignmentDirectional.bottomCenter,
            child: StreamBuilder(
          stream: _userDocument,
          builder: (context, userDocument) {
            if (userDocument.data != null) {
              return RawMaterialButton(
                constraints: BoxConstraints.tight(const Size(25, 25)),
                onPressed: () async {
                  await userRepository.checkConnectivity();
                  if (userRepository.isConnected == true) {
                    _handleFavoriteStoriesChanged(storyID, userRepository);
                  } else {
                    Flushbars().connetivityFlushbar(context);
                  }
                },
                child: Icon(
                  userFavorites.favorites.contains(storyID) == true
                      ? Icons.favorite
                      : Icons.favorite_border,
                  size: 12,
                  color: Colors.white.withOpacity(0.6),
                ),
                elevation: 0,
                fillColor: Colors.black87.withOpacity(0.8),
                shape: const CircleBorder(),
              );
            } else {
              return RawMaterialButton(
                constraints: BoxConstraints.tight(const Size(25, 25)),
                onPressed: () => null,
                elevation: 0,
                fillColor: Colors.black87.withOpacity(0.8),
                shape: const CircleBorder(),
              );
            }
          },
        ),
      ),
    );
  }
}
