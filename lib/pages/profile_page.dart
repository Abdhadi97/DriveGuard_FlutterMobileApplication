import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
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

      if (docSnapshot.exists && mounted) {
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

  //user log out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  //prompt options; select or take photo
  void _showImageEditorModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: SizedBox(
            height: 320,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    'Make Selection!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Select one of the options given below to edit your profile photo.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Iconsax.gallery),
                    onPressed: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size.fromHeight(70),
                    ),
                    label: const Text(
                      'Pick from Gallery',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    icon: const Icon(Iconsax.camera),
                    onPressed: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size.fromHeight(70),
                    ),
                    label: const Text(
                      'Take a Photo',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _profileImage != null
                        ? CircleAvatar(
                            radius: 50,
                            backgroundImage: FileImage(_profileImage!),
                          )
                        : (_imageUrl != null
                            ? CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(_imageUrl!),
                              )
                            : const CircleAvatar(
                                radius: 50,
                                child: Icon(Icons.person, size: 50),
                              )),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: IconButton(
                        icon: const Icon(Icons.edit),
                        iconSize: 15,
                        color: Colors
                            .black, // or any color you prefer for the icon
                        onPressed: _showImageEditorModal,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_firstName != null && _lastName != null)
                    Text('Name: $_firstName $_lastName'),
                  if (_email != null) Text('Email: $_email'),
                  if (_phoneNum != null) Text('Phone: $_phoneNum'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
