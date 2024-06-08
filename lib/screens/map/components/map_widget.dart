import 'package:drive_guard/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapWidget extends StatefulWidget {
  final Set<Marker> markers;
  final Function(GoogleMapController) onMapCreated;

  const MapWidget({
    Key? key,
    required this.markers,
    required this.onMapCreated,
  }) : super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  double _radius = 500; // Initial radius in meters

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    if (userProvider.user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                userProvider.user!.curLoc!.latitude,
                userProvider.user!.curLoc!.longitude,
              ),
              zoom: 15,
            ),
            circles: {
              Circle(
                circleId: const CircleId("User"),
                center: LatLng(
                  userProvider.user!.curLoc!.latitude,
                  userProvider.user!.curLoc!.longitude,
                ),
                radius: _radius,
                strokeWidth: 1,
                strokeColor: Colors.grey,
                fillColor: const Color(0xFF006491).withOpacity(0.2),
              ),
            },
            markers: widget.markers,
            onMapCreated: (controller) => widget.onMapCreated(controller),
            zoomControlsEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            tiltGesturesEnabled: false,
            compassEnabled: false,
            mapToolbarEnabled: false,
          ),
        ),
        Slider(
          value: _radius,
          min: 100,
          max: 1000,
          divisions: 9,
          label: 'Radius: ${_radius.toStringAsFixed(0)} meters',
          onChanged: (value) {
            setState(() {
              _radius = value;
            });
          },
        ),
      ],
    );
  }
}
