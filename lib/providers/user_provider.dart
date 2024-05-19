import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:drive_guard/models/user.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (docSnapshot.exists) {
        _user = UserModel.fromDocumentSnapshot(docSnapshot);
        notifyListeners();
      }
    }
  }

  Future<void> updateUserProfileImage(File imageFile) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Upload image to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${user.uid}.jpg');
      final uploadTask = storageRef.putFile(imageFile);

      // Listen for upload completion
      await uploadTask.whenComplete(() {});

      // Get download URL
      final imageUrl = await storageRef.getDownloadURL();

      // Update Firestore document with new image URL
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'imageurl': imageUrl});

      // Update the local user model and notify listeners
      _user?.imageUrl = imageUrl;
      notifyListeners();
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}
