import 'package:drive_guard/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:drive_guard/providers/user_provider.dart';

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
  double _radius = 0.5; // Initial radius in kilometers
  final List<double> _radiusOptions = [
    0.5,
    1.0,
    1.5,
    2.0,
    2.5,
    3.0,
    3.5,
    4.0,
    4.5,
    5.0
  ]; // Radius options in kilometers

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (userProvider.user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        LatLng userLocation = LatLng(
          userProvider.user!.curLoc!.latitude,
          userProvider.user!.curLoc!.longitude,
        );

        return Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: userLocation,
                      zoom: 15,
                    ),
                    circles: {
                      Circle(
                        circleId: const CircleId("User"),
                        center: userLocation,
                        radius: _radius * 1000, // Convert radius to meters
                        strokeWidth: 1,
                        strokeColor: Colors.grey,
                        fillColor: const Color(0xFF006491).withOpacity(0.2),
                      ),
                    },
                    markers: widget.markers,
                    onMapCreated: (controller) =>
                        widget.onMapCreated(controller),
                    zoomControlsEnabled: false,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    tiltGesturesEnabled: false,
                    compassEnabled: false,
                    mapToolbarEnabled: false,
                  ),
                  Positioned(
                    bottom: 20,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: DropdownButton<double>(
                        value: _radius,
                        onChanged: (double? newValue) {
                          setState(() {
                            _radius = newValue!;
                          });
                        },
                        items: _radiusOptions
                            .map<DropdownMenuItem<double>>((double value) {
                          return DropdownMenuItem<double>(
                            value: value,
                            child: Text('${value.toStringAsFixed(1)} km'),
                          );
                        }).toList(),
                        underline: Container(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
