import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stor_paper/utils/firestore.dart';
import 'package:stor_paper/utils/user_repository.dart';

import 'flushbars.dart';

// when tapped it updates list of favorites and is 
// either an outline or filled in depending

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    @required this.storyID,
  });

  final String storyID;

  @override
  Widget build(BuildContext context) {
    final userRepository = Provider.of<UserRepository>(context);

    final Stream _userFavorites = Firestore.instance
        .collection('users')
        .document(userRepository.user.uid)
        .snapshots();

    void _handleFavoriteStoriesChanged(String storyID) {
      updateFavorites(userRepository.user.uid, storyID);
    }

    return StreamBuilder(
      stream: _userFavorites,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return RawMaterialButton(
            constraints: BoxConstraints.tight(const Size(25, 25)),
            onPressed: () async {
              await userRepository.checkConnectivity();
              if (userRepository.isConnected == true) {
                _handleFavoriteStoriesChanged(storyID);
              } else {
                Flushbars().connetivityFlushbar(context);
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
            fillColor: Colors.black.withOpacity(0.03),
            shape: const CircleBorder(),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
