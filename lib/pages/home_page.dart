import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_guard/components/map_widget.dart';
import 'package:drive_guard/pages/login_page.dart';
import 'package:drive_guard/pages/profile_page.dart';
import 'package:drive_guard/pages/workshop_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' show asin, cos, pi, pow, sin, sqrt;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final user = FirebaseAuth.instance.currentUser!;
  double overlayHeight = 0.3; // Initial height of the overlay
  String firstName = '';
  String lastName = '';
  double _currentRange = 5;
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
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
    Navigator.pushReplacement(
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

  // Calculate distance between two coordinate
  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const double radiusOfEarth = 6371; // Earth's radius in kilometers

    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);
    lat1 = _degreesToRadians(lat1);
    lat2 = _degreesToRadians(lat2);

    double a =
        pow(sin(dLat / 2), 2) + pow(sin(dLon / 2), 2) * cos(lat1) * cos(lat2);
    double c = 2 * asin(sqrt(a));

    return radiusOfEarth * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  // Get nearby workshop location (latitude, longitude)
  Future<void> _getWorkshopLocations() async {
    Position userPosition = await Geolocator.getCurrentPosition();
    QuerySnapshot workshopSnapshot =
        await FirebaseFirestore.instance.collection('workshops').get();

    setState(() {
      _markers.clear();
      for (var document in workshopSnapshot.docs) {
        Map<String, dynamic> workshopData =
            document.data() as Map<String, dynamic>;
        GeoPoint location = workshopData['location'] as GeoPoint;
        String name = workshopData['name'] as String;

        // Calculate distance between user and workshop
        double distance = _calculateDistance(
          userPosition.latitude,
          userPosition.longitude,
          location.latitude,
          location.longitude,
        );

        // Filter workshops within specific range
        if (distance <= _currentRange) {
          _addWorkshopMarker(name, location.latitude, location.longitude);
        }
      }
    });
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
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      overlayHeight -=
          details.primaryDelta! / MediaQuery.of(context).size.height;
      overlayHeight = overlayHeight.clamp(0.3, 0.8);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    setState(() {
      overlayHeight = overlayHeight <= 0.4
          ? 0.3
          : overlayHeight <= 0.6
              ? 0.5
              : 0.8;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final height = mediaQuery.height;

    return Scaffold(
      key: _scaffoldKey,
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
                        builder: (context) => const WorkshopList(),
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

      // Main content of homepage
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: SizedBox(
                  height: height * 0.7,
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

          // User location floating button
          Positioned(
            bottom: 250,
            right: 20,
            child: SizedBox(
              height: 40,
              width: 40,
              child: FloatingActionButton(
                heroTag: 'userLocation',
                onPressed: _getUserLocation,
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

          // Open drawer floating button
          Positioned(
            top: 50,
            left: 20,
            child: SizedBox(
              height: 50,
              width: 50,
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
                  size: 25,
                ),
              ),
            ),
          ),

          // Overlay above map
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onVerticalDragUpdate: _handleDragUpdate,
              onVerticalDragEnd: _handleDragEnd,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height * overlayHeight,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Column(
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
                            onPressed: _getWorkshopLocations,
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
                        Text(
                          'Filter Distance Range: ${_currentRange.toStringAsFixed(1)} km',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        Slider(
                          value: _currentRange,
                          min: 0,
                          max: 20, // Maximum range can be adjusted as needed
                          divisions: 10,
                          onChanged: (double value) {
                            setState(() {
                              _currentRange = value;
                              _getWorkshopLocations();
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
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
