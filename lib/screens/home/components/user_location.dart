import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_guard/screens/map/open_map.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:drive_guard/providers/user_provider.dart';

import 'section_title.dart';

class UserLocation extends StatefulWidget {
  const UserLocation({Key? key}) : super(key: key);

  @override
  _UserLocationState createState() => _UserLocationState();
}

class _UserLocationState extends State<UserLocation> {
  String _currentAddress = "Tap to fetch location";

  @override
  void initState() {
    super.initState();
    _loadStoredLocation();
  }

  Future<void> _loadStoredLocation() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    // Check if user data is already loaded
    if (userProvider.user != null) {
      setState(() {
        _currentAddress =
            userProvider.user?.curAddress ?? "Tap to fetch location";
      });
    } else {
      setState(() {
        _currentAddress = "Loading...";
      });
      await userProvider.fetchUserData();
      setState(() {
        _currentAddress =
            userProvider.user?.curAddress ?? "Tap to fetch location";
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    setState(() {
      _currentAddress = "Fetching location...";
    });

    // Test if location services are enabled.
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _currentAddress = "Location services are disabled.";
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _currentAddress = "Location permissions are denied";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _currentAddress =
            "Location permissions are permanently denied, we cannot request permissions.";
      });
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      await userProvider.updateUserLocation(position);
      await userProvider
          .updateUserAddress(GeoPoint(position.latitude, position.longitude));
    } catch (e) {
      print('Error getting location: $e');
      setState(() {
        _currentAddress = "Error getting location.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SectionTitle(
                title: "Current Location",
                press: () {
                  Navigator.pushNamed(context, OpenMapScreen.routeName);
                },
              ),
            ),
            GestureDetector(
              onTap: _getCurrentLocation,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A3298),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  userProvider.user?.curAddress ?? _currentAddress,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
