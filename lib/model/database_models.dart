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
    final Map volumeMap = singleVolume.data;

    return Volume(
      id: singleVolume.documentID,
      productID: volumeMap['productID'],
      volumeTitle: volumeMap['volumeTitle'],
      image: volumeMap['image'],
      numberOfStories: volumeMap['numberOfStories'],
      stories: List<Map>.from(volumeMap['stories']),
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

class Story {

  const Story({
    this.id,
    this.blurb,
    this.glossary,
    this.image,
    this.paragraphs,
    this.readTime,
    this.storyTitle,
  });

  factory Story.fromFirestore(Map storyData) {
    return Story (
      id: storyData['id'],
      blurb: storyData['blurb'],
      glossary: storyData['glossary'],
      image: storyData['image'],
      paragraphs: storyData['paragraphs'],
      readTime: storyData['readTime'],
      storyTitle: storyData['storyTitle'],
    );
  }

  final String id;
  final String blurb;
  final List glossary;
  final String image;
  final List paragraphs;
  final String readTime;
  final String storyTitle;
}