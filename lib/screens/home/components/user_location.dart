import 'package:cloud_firestore/cloud_firestore.dart';
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
  @override
  void initState() {
    super.initState();
    _loadStoredLocation();
  }

  Future<void> _loadStoredLocation() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.user != null) {
      setState(() {});
    }
  }

  Future<void> _getCurrentLocation() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    setState(() {
      userProvider.user?.curAddress = "Fetching location...";
    });

    // Test if location services are enabled.
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        userProvider.user?.curAddress = "Location services are disabled.";
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          userProvider.user?.curAddress = "Location permissions are denied";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        userProvider.user?.curAddress =
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
        userProvider.user?.curAddress = "Error getting location.";
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
                  _getCurrentLocation();
                },
                buttonText: 'Refresh',
              ),
            ),
            GestureDetector(
              onTap: () {
                _getCurrentLocation();
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: AssetImage("assets/images/map_userLoc.jpeg"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Text(
                  userProvider.user?.curAddress ?? "Tap to fetch location",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
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
