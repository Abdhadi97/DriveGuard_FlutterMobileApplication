import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _profileImage;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _phoneNum;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (docSnapshot.exists) {
        setState(() {
          _firstName = docSnapshot.get('firstname');
          _lastName = docSnapshot.get('lastname');
          _email = docSnapshot.get('email');
          _phoneNum = docSnapshot.get('phoneNum');
          _imageUrl = docSnapshot.get('imageurl');
        });
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });

      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Upload image to Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('${user.uid}.jpg');
        final uploadTask = storageRef.putFile(_profileImage!);

        // Listen for upload completion
        await uploadTask.whenComplete(() {});

        // Get download URL
        final imageUrl = await storageRef.getDownloadURL();

        // Update Firestore document with new image URL
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'imageurl': imageUrl});
      }
    }
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _profileImage != null
                    ? CircleAvatar(
                        radius: 60,
                        backgroundImage: FileImage(_profileImage!),
                      )
                    : (_imageUrl != null
                        ? CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(_imageUrl!),
                          )
                        : const CircleAvatar(
                            radius: 60,
                            child: Icon(Icons.person, size: 60),
                          )),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  child: const Text('Pick from Gallery'),
                ),
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.camera),
                  child: const Text('Take a Photo'),
                ),
                const SizedBox(height: 20),
                if (_firstName != null && _lastName != null)
                  Text('Name: $_firstName $_lastName'),
                if (_email != null) Text('Email: $_email'),
                if (_phoneNum != null) Text('Phone: $_phoneNum'),
                const SizedBox(height: 20),
                const Text('test'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
