import 'package:cloud_firestore/cloud_firestore.dart';

// writes to firebase and updates users favorites 
// in response to them favoriting stories
// checks if favorites list exists and either adds
// or removes stories from the list in firebase

Future<void> updateFavorites(String uid, String storyId) {
 final DocumentReference favoritesReference =
      Firestore.instance.collection('users').document(uid);

  return Firestore.instance.runTransaction((Transaction tx) async {
    final DocumentSnapshot postSnapshot = await tx.get(favoritesReference);
    if (postSnapshot.exists) {
      if (!postSnapshot.data['favorites'].contains(storyId)) {
        await tx.update(favoritesReference, <String, dynamic>{
          'favorites': FieldValue.arrayUnion([storyId])
        });
      } else {
        await tx.update(favoritesReference, <String, dynamic>{
          'favorites': FieldValue.arrayRemove([storyId])
        });
      }
    } else {
      await tx.set(favoritesReference, {
        'favorites': [storyId]
      });
    }
  }).catchError((error) {
    print('Error: $error');
  });
}


