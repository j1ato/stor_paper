// Parses data from firebase into volume contsructor

import 'package:cloud_firestore/cloud_firestore.dart';

class Volume {
  const Volume({
    this.id,
    this.productID,
    this.volumeTitle,
    this.image,
    this.numberOfStories,
    this.stories,
  });

  factory Volume.fromFirestore(DocumentSnapshot singleVolume) {
    final Map data = singleVolume.data;

    return Volume(
      id: singleVolume.documentID,
      productID: data['productID'],
      volumeTitle: data['volumeTitle'],
      image: data['image'],
      numberOfStories: data['numberOfStories'],
      stories: List<Map>.from(data['stories']),
    );
  }

  final String id;
  final String productID;
  final String volumeTitle;
  final String image;
  final String numberOfStories;
  final List<Map> stories;

}

class UserFavorites {
  const UserFavorites({
    this.favorites,
  });

  factory UserFavorites.fromFirestore(Map favoritesData) {
    print('this is really the users favorites ${favoritesData['favorites']}');

    return UserFavorites(
      favorites: favoritesData['favorites'],
    );
  }

  final List favorites;
}
