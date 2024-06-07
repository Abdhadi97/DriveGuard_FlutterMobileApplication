import 'package:drive_guard/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class LocationTest extends StatefulWidget {
  const LocationTest({Key? key}) : super(key: key);

  @override
  State<LocationTest> createState() => _LocationTestState();
}

class _LocationTestState extends State<LocationTest> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    _updateMapWithUserLocation(position.latitude, position.longitude);
  }

  Future<void> _getWorkshopLocationsFromDatabase() async {
    QuerySnapshot workshopSnapshot =
        await _firestore.collection('workshops').get();

    workshopSnapshot.docs.forEach((DocumentSnapshot document) {
      Map<String, dynamic> workshopData =
          document.data() as Map<String, dynamic>;
      GeoPoint location = workshopData['location'] as GeoPoint;
      String name = workshopData['name'] as String;
      double latitude = location.latitude;
      double longitude = location.longitude;
      _addWorkshopMarker(name, latitude, longitude);
    });
  }

  void _updateMapWithUserLocation(double latitude, double longitude) {
    LatLng position = LatLng(latitude, longitude);
    _mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 15)));
    setState(() {
      _markers.clear();
      _markers.add(Marker(
        markerId: const MarkerId("userLocation"),
        position: position,
        infoWindow: const InfoWindow(
          title: "Your Location",
        ),
      ));
    });
  }

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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Google Map',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: kSecondaryColor,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: kSecondaryColor,
          ),
        ),
        leadingWidth: 80,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(4.2105, 101.9758),
                zoom: 7,
              ),
              myLocationButtonEnabled: false,
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
            ),
          ),
        ],
      ),
    );
  }
}
