import 'package:drive_guard/providers/user_provider.dart';
import 'package:drive_guard/providers/workshop_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'components/map_widget.dart';

class OpenMapScreen extends StatefulWidget {
  const OpenMapScreen({Key? key}) : super(key: key);
  static String routeName = "/open_map_screen";

  @override
  State<OpenMapScreen> createState() => _OpenMapScreenState();
}

class _OpenMapScreenState extends State<OpenMapScreen> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).fetchUserData();
    Provider.of<WorkshopProvider>(context, listen: false).fetchWorkshops();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Find Nearest Workshop',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        leadingWidth: 80,
        centerTitle: true,
        backgroundColor: Colors.black.withOpacity(0.5),
      ),
      body: Center(
        child: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            if (userProvider.user == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return SizedBox(
              height: screenHeight,
              width: screenWidth,
              child: MapWidget(
                markers: _markers,
                onMapCreated: (controller) {
                  _mapController = controller;
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
