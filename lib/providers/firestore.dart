import 'package:cloud_firestore/cloud_firestore.dart';

// writes to firebase and updates users favorites
// in response to them favoriting stories
// checks if favorites list exists and either adds
// or removes stories from the list in firebase

class UserFavourites {

  Future<void> updateFavorites(String userID, String storyID) {
    FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
    DocumentReference favoritesReference = firestoreInstance.collection('users').doc(userID);

    return firestoreInstance
        .runTransaction((Transaction favoritesTransaction) async {
     DocumentSnapshot favouritesSnapshot = await favoritesTransaction.get(favoritesReference);
      if (favouritesSnapshot.exists) {
        await toggleFavourites(favouritesSnapshot, storyID,
            favoritesTransaction, favoritesReference);
      } else {
        await createFavourites(favoritesTransaction, storyID, favoritesReference);
      }
    }).catchError((error) {
      print('Error: $error');
    });
  }

  Future createFavourites(
      Transaction favoritesTransaction, String storyId, DocumentReference favoritesReference) async {
    await favoritesTransaction.set(favoritesReference, {
      'favorites': [storyId]
    });
  }

  Future<void>toggleFavourites(
      DocumentSnapshot favouritesSnapshot,
      String storyID,
      Transaction favoritesTransaction,
      DocumentReference favoritesReference) async {
    Map <String, dynamic> favouritesData = favouritesSnapshot.data() as Map <String, dynamic>;

    if (!favouritesData.containsValue(storyID)) {
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
