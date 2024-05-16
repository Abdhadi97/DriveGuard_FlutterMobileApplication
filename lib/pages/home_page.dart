import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_guard/components/map_widget.dart';
import 'package:drive_guard/pages/login_page.dart';
import 'package:drive_guard/pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final user = FirebaseAuth.instance.currentUser!;
  bool isOverlayVisible = false;
  double overlayHeight = 0.2; // Initial height of the overlay

  String firstName = '';
  String lastName = '';

  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  // FETCH USER DATA
  Future<void> fetchUserData() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    setState(() {
      firstName = userDoc['firstname'];
      lastName = userDoc['lastname'];
    });
  }

  // USER SIGN OUT
  void signUserOut() {
    FirebaseAuth.instance.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  // Get user location; (latitude, longitude)
  Future<void> _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    _updateMapWithUserLocation(position.latitude, position.longitude);
  }

  // Get workshop location (latitude, longitude)
  Future<void> _getWorkshopLocations() async {
    QuerySnapshot workshopSnapshot =
        await FirebaseFirestore.instance.collection('workshops').get();

    for (var document in workshopSnapshot.docs) {
      Map<String, dynamic> workshopData =
          document.data() as Map<String, dynamic>;
      GeoPoint location = workshopData['location'] as GeoPoint;
      String name = workshopData['name'] as String;
      double latitude = location.latitude;
      double longitude = location.longitude;
      _addWorkshopMarker(name, latitude, longitude);
    }
  }

  // Update latest user location in map
  void _updateMapWithUserLocation(double latitude, double longitude) {
    LatLng position = LatLng(latitude, longitude);
    _mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 15)));
    setState(() {
      _markers.clear();
    });
  }

  // Display workshop marker in map
  void _addWorkshopMarker(String name, double latitude, double longitude) {
    LatLng position = LatLng(latitude, longitude);
    _markers.add(Marker(
      markerId: MarkerId(name),
      position: position,
      infoWindow: InfoWindow(
        title: name,
      ),
    ));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // SIDE NAVIGATION
      drawer: Drawer(
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  height: 140, // Adjust the height as needed
                  child: DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey, // Shadow color
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // user's name
                        Text(
                          '$firstName $lastName',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                        // user's email
                        Text(
                          user.email!,
                          style: const TextStyle(
                            fontSize: 14,
                            letterSpacing: 0,
                            fontStyle: FontStyle.italic,
                            color: Colors.white70,
                          ),
                        ),
                      ],
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
                        builder: (context) => Container(),
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
                heroTag: 'signUserOut',
                onPressed: () {
                  signUserOut();
                },
                child: const Icon(Icons.logout),
              ),
            ),
          ],
        ),
      ),
      // Adjusted body of the HomePage widget
      body: Stack(
        children: [
          // GOOGLE MAP CONTENT
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: MapWidget(
                    markers: _markers,
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                  ),
                ),
              ),
            ],
          ),

          Positioned(
            bottom: 240,
            right: 15,
            child: SizedBox(
              height: 40,
              width: 40,
              child: FloatingActionButton(
                heroTag: 'userLocation',
                onPressed: () {
                  _getUserLocation();
                },
                shape: const CircleBorder(),
                backgroundColor: Colors.white,
                child: const Icon(
                  Icons.my_location,
                  color: Colors.blue,
                  size: 20,
                ),
              ),
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
                              onPressed: () {
                                _getWorkshopLocations();
                              },
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
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Floating button to open drawer at top left
          Positioned(
            top: 50,
            left: 15,
            child: SizedBox(
              height: 40,
              width: 40,
              child: FloatingActionButton(
                heroTag: 'openDrawer',
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                shape: const CircleBorder(),
                backgroundColor: Colors.white,
                child: const Icon(
                  Icons.menu,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
