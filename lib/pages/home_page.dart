import 'package:drive_guard/pages/location_test.dart';
import 'package:drive_guard/pages/login_page.dart';
import 'package:drive_guard/pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  bool isOverlayVisible = false;
  double overlayHeight = 0.2; // Initial height of the overlay

  //sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(
                  height: 100, // Adjust the height as needed
                  child: DrawerHeader(
                    child: Text(
                      'Drawer Head',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.account_circle),
                  title: const Text('My profile'),
                  onTap: () {
                    // Navigate to profile page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.pin_drop),
                  title: const Text('Location'),
                  onTap: () {
                    // Navigate to location page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LocationTest(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text('History'),
                  onTap: () {
                    // Navigate to history page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Container(),
                      ),
                    );
                  },
                ),
              ],
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: () {
                  signUserOut();
                },
                child: const Icon(Icons.logout),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Map Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'LOGGED IN AS: ${user.email!}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),

          // Draggable Overlay: Request page
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                setState(() {
                  overlayHeight -= details.primaryDelta! /
                      MediaQuery.of(context).size.height;
                  overlayHeight = overlayHeight.clamp(
                      0.2, 0.8); // Clamp the height between 20% and 80%
                });
              },
              onVerticalDragEnd: (details) {
                setState(() {
                  // Snap the overlay to 80% if it's greater than 0.6
                  if (overlayHeight <= 0.2) {
                    overlayHeight = 0.2;
                  } else if (overlayHeight > 0.2 && overlayHeight <= 0.5) {
                    overlayHeight = 0.5;
                  } else if (overlayHeight > 0.5) {
                    overlayHeight = 0.8;
                  }
                });
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height * overlayHeight,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    physics: overlayHeight >= 0.8
                        ? const NeverScrollableScrollPhysics()
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            'Request Assistance',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Need an Assistance? Get it with just one click.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: const Text(
                                'See Available Workshops',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
