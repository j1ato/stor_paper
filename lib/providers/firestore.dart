import 'package:cloud_firestore/cloud_firestore.dart';

// writes to firebase and updates users favorites
// in response to them favoriting stories
// checks if favorites list exists and either adds
// or removes stories from the list in firebase

class UserFavourites {
  DocumentReference favoritesReference;
  DocumentSnapshot favouritesSnapshot;
  Firestore firestoreInstance = Firestore.instance;

  Future<void> updateFavorites(String userID, String storyID) {
    favoritesReference = firestoreInstance.collection('users').document(userID);

    return firestoreInstance
        .runTransaction((Transaction favoritesTransaction) async {
      favouritesSnapshot = await favoritesTransaction.get(favoritesReference);
      if (favouritesSnapshot.exists) {
        await toggleFavourites(favouritesSnapshot, storyID,
            favoritesTransaction, favoritesReference);
      } else {
        await createFavourites(favoritesTransaction, storyID);
      }
    }).catchError((error) {
      print('Error: $error');
    });
  }

  Future createFavourites(
      Transaction favoritesTransaction, String storyId) async {
    await favoritesTransaction.set(favoritesReference, {
      'favorites': [storyId]
    });
  }

  Future<void>toggleFavourites(
      DocumentSnapshot favouritesSnapshot,
      String storyID,
      Transaction favoritesTransaction,
      DocumentReference favoritesReference) async {
    if (!favouritesSnapshot.data['favorites'].contains(storyID)) {
      await addFavourite(
          favoritesTransaction, favoritesReference, storyID);
    } else {
      await removeFavourite(favoritesTransaction, favoritesReference, storyID);
    }
  }

  Future<void>removeFavourite(Transaction favoritesTransaction,
      DocumentReference favoritesReference, String storyId) async {
    await favoritesTransaction.update(favoritesReference, <String, dynamic>{
      'favorites': FieldValue.arrayRemove([storyId])
    });
  }

  Future<void> addFavourite(Transaction favoritesTransaction,
      DocumentReference favoritesReference, String storyID) async {
    await favoritesTransaction.update(favoritesReference, <String, dynamic>{
      'favorites': FieldValue.arrayUnion([storyID])
    });
  }
}
