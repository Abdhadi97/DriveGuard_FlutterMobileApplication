import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(LineAwesomeIcons.angle_left),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: signUserOut,
        backgroundColor: Colors.amber,
        child: const Icon(
          Icons.logout,
          color: Colors.black,
        ), // You can change the color
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // Align to bottom right
    );
  }
}
