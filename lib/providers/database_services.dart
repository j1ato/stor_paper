import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/database_models.dart';

class DatabaseServices extends ChangeNotifier {
  final Firestore _db = Firestore.instance;


  Stream<List<Volume>> streamVolumes() {
    final volumes = _db.collection('Volumes');
    return volumes.snapshots().map((volumesList) => volumesList.documents
        .map((singleVolume) => Volume.fromFirestore(singleVolume))
        .toList());
  }

  Stream<UserFavorites> streamFavorites(FirebaseUser user) {
    print('this is the users id: ${user.uid}');
    return _db
        .collection('users')
        .document(user.uid)
        .snapshots()
        .map((singleUser) => UserFavorites.fromFirestore(singleUser.data));
  }
}
