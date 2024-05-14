import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationTest extends StatefulWidget {
  const LocationTest({Key? key}) : super(key: key);

  @override
  State<LocationTest> createState() => _LocationTestState();
}

class _LocationTestState extends State<LocationTest> {
  Position? _currentLocation;
  String _currentAddress = "";
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      print(
          "Location permissions are permanently denied, we cannot request permissions.");
      return;
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        print("Location permissions are denied (actual value: $permission).");
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLocation = position;
    });
    _getAddressFromCoordinates();
    _updateMapLocation();
  }

  Future<void> _getAddressFromCoordinates() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentLocation!.latitude, _currentLocation!.longitude);
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            "${place.street}, ${place.postalCode}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  void _updateMapLocation() {
    if (_currentLocation != null) {
      LatLng position =
          LatLng(_currentLocation!.latitude, _currentLocation!.longitude);
      _mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: position, zoom: 15)));
      setState(() {
        _markers.clear();
        _markers.add(Marker(
          markerId: const MarkerId("currentLocation"),
          position: position,
          infoWindow: const InfoWindow(
            title: "Your Location",
          ),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Map Example'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(0, 0),
                zoom: 2,
              ),
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: _getCurrentLocation,
              child: const Text("Get Location"),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Your Current Location:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _currentLocation != null
                              ? "Latitude: ${_currentLocation!.latitude}; Longitude: ${_currentLocation!.longitude}"
                              : "Latitude: Unknown; Longitude: Unknown",
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Location Address:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _currentAddress.isNotEmpty
                        ? _currentAddress
                        : "Address not available",
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
