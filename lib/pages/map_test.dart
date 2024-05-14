import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapTest extends StatefulWidget {
  const MapTest({Key? key}) : super(key: key);

  @override
  _MapTestState createState() => _MapTestState();
}

class _MapTestState extends State<MapTest> {
  late GoogleMapController mapController;
  late LatLng _currentPosition = const LatLng(37.7749, -122.4194);

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink,
      appBar: AppBar(
        title: const Text('Google Maps Example'),
      ),
      body: Center(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentPosition,
                zoom: 12.0,
              ),
              onMapCreated: (GoogleMapController controller) {
                setState(() {
                  mapController = controller;
                });
              },
            ),
            Positioned(
              bottom: 16.0,
              right: 16.0,
              child: ElevatedButton(
                onPressed: _getCurrentLocation,
                child: const Text('Locate Me'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
