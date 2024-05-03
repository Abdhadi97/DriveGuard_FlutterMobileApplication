import 'package:drive_guard/pages/location_test.dart';
import 'package:drive_guard/pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePapeState();
}

class _HomePapeState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  int currentPageIndex = 0;

  /* sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: Colors.black,
        title: ,
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
            color: Colors.white,
          )
        ],
      ),*/
      body: _getBody(currentPageIndex),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.pin_drop),
            icon: Icon(Icons.pin_drop_outlined),
            label: 'Location',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.list),
            icon: Icon(Icons.list_outlined),
            label: 'History',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person_2),
            icon: Icon(Icons.person_2_outlined),
            label: 'Profile',
          )
        ],
      ),
    );
  }

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'LOGGED IN AS: ${user.email!}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              /*ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LocationTest(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: const Size(100, 40),
                ),
                child: const Text('See my location'),
              ),*/
            ],
          ),
        );
      case 1:
        // Navigate to Location page
        return const LocationTest(); // Assuming LocationTest is the page you want to navigate to
      case 2:
        // Navigate to History page
        return Container(); // Placeholder for History page
      case 3:
        // Navigate to Profile page
        return const ProfilePage(); // Placeholder for Profile page
      default:
        return Container(); // Placeholder for other pages
    }
  }
}
