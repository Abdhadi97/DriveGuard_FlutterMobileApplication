import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatelessWidget {
  final Set<Marker> markers;
  final Function(GoogleMapController) onMapCreated;

  const MapWidget({
    super.key,
    required this.markers,
    required this.onMapCreated,
  });

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: LatLng(4.2105, 101.9758),
        zoom: 7,
      ),
      markers: markers,
      onMapCreated: onMapCreated,
      zoomControlsEnabled: false,
    );
  }
}
