import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/database_models.dart';

class DatabaseServices extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Volume>> streamVolumes() {
    return _db.collection('Volumes').snapshots().map((volumesList) =>
        volumesList.docs
            .map((singleVolume) => Volume.fromFirestore(singleVolume))
            .toList());
  }

  Stream<UserFavorites> streamFavorites(User user) {
    print('this is the users id: ${user.uid}');
    return _db.collection('users').doc(user.uid).snapshots().map((singleUser) =>
        UserFavorites.fromFirestore(singleUser.data() as Map<String, dynamic>));
  }
}
