import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:drive_guard/providers/user_provider.dart';
import 'package:drive_guard/providers/workshop_provider.dart';
import 'dart:math' as math;

class MapWidget extends StatefulWidget {
  final Function(GoogleMapController) onMapCreated;

  const MapWidget({
    Key? key,
    required this.onMapCreated,
    required Set<Marker> markers,
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
  late GoogleMapController _mapController;

  Marker? _selectedMarker;
  double? _selectedMarkerDistance;

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, WorkshopProvider>(
      builder: (context, userProvider, workshopProvider, child) {
        if (userProvider.user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        LatLng userLocation = LatLng(
          userProvider.user!.curLoc!.latitude,
          userProvider.user!.curLoc!.longitude,
        );

        // Filter workshops within the specified radius
        Set<Marker> filteredMarkers =
            workshopProvider.workshops.where((workshop) {
          final workshopData = workshop.data() as Map<String, dynamic>;
          final workshopLocation = LatLng(
            workshopData['location'].latitude,
            workshopData['location'].longitude,
          );
          return _calculateDistance(userLocation, workshopLocation) <= _radius;
        }).map((workshop) {
          final workshopData = workshop.data() as Map<String, dynamic>;
          final workshopLocation = LatLng(
            workshopData['location'].latitude,
            workshopData['location'].longitude,
          );
          return Marker(
            markerId: MarkerId(workshop.id),
            position: workshopLocation,
            onTap: () {
              final distance = _calculateDistance(
                userLocation,
                workshopLocation,
              );
              setState(() {
                _selectedMarker = Marker(
                  markerId: MarkerId(workshop.id),
                  position: workshopLocation,
                  infoWindow: InfoWindow(
                    title: workshopData['name'],
                  ),
                );
                _selectedMarkerDistance = distance;
              });
            },
          );
        }).toSet();

        return Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: userLocation,
                zoom: _getZoomLevel(_radius),
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
              markers: filteredMarkers,
              onMapCreated: (controller) {
                _mapController = controller;
                widget.onMapCreated(controller);
              },
              zoomControlsEnabled: false,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              tiltGesturesEnabled: false,
              compassEnabled: false,
              mapToolbarEnabled: false,
            ),
            if (_selectedMarker != null) ...[
              Positioned(
                bottom: 50,
                left: 20,
                right: 20,
                child: Card(
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Workshop',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  _selectedMarker = null;
                                  _selectedMarkerDistance = null;
                                });
                              },
                            )
                          ],
                        ),
                        Text(
                          'Name: ${_selectedMarker!.infoWindow.title}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        if (_selectedMarkerDistance != null) ...[
                          const SizedBox(height: 10),
                          Text(
                            'Distance: ${_selectedMarkerDistance!.toStringAsFixed(2)} km',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            // Handle request button press
                          },
                          child: const Text('Request'),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            Positioned(
              top: 100,
              right: 20,
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
                      _mapController.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: userLocation,
                            zoom: _getZoomLevel(_radius),
                          ),
                        ),
                      );
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
        );
      },
    );
  }

  // Haversine formula to calculate the distance between two coordinates
  double _calculateDistance(LatLng start, LatLng end) {
    const double earthRadius = 6371; // Earth radius in kilometers

    final double lat1 = start.latitude;
    final double lon1 = start.longitude;
    final double lat2 = end.latitude;
    final double lon2 = end.longitude;

    final double dLat = _degreeToRadian(lat2 - lat1);
    final double dLon = _degreeToRadian(lon2 - lon1);

    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreeToRadian(lat1)) *
            math.cos(_degreeToRadian(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreeToRadian(double degree) {
    return degree * math.pi / 180;
  }

  // Calculate the appropriate zoom level for a given radius
  double _getZoomLevel(double radius) {
    return (14.5 - math.log(radius) / math.log(2)).clamp(0.0, 21.0);
  }
}
