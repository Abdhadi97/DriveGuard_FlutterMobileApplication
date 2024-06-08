import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
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
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${user.uid}.jpg');
      final uploadTask = storageRef.putFile(imageFile);

      await uploadTask.whenComplete(() {});
      final imageUrl = await storageRef.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'imageurl': imageUrl});

      _user?.imageUrl = imageUrl;
      notifyListeners();
    }
  }

  Future<void> updateUserLocation(Position position) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final geoPoint = GeoPoint(position.latitude, position.longitude);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'current location': geoPoint,
      });

      _user?.curLoc = geoPoint;
      notifyListeners();
      updateUserAddress(geoPoint);
    }
  }

  Future<void> updateUserAddress(GeoPoint geoPoint) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            geoPoint.latitude, geoPoint.longitude);

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          String address =
              "${place.street}, ${place.locality}, ${place.postalCode}, ${place.administrativeArea}, ${place.country}";

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({
            'current address': address,
          });

          _user?.curAddress = address;
          notifyListeners();
        }
      } catch (e) {
        print('Error updating address: $e');
      }
    }
  }

  void setCurrentAddress(String address) {
    _user?.curAddress = address;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
    clearUser();
  }

  Future<void> deleteUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();
      await user.delete();
      signOut();
    }
  }
}
