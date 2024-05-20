import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapWidget extends StatelessWidget {
  final Set<Marker> markers;
  final Function(GoogleMapController) onMapCreated;

  const MapWidget({
    Key? key,
    required this.markers,
    required this.onMapCreated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: LatLng(4.2105, 101.9758), // Set this to your desired location
        zoom: 7,
      ),
      markers: markers,
      onMapCreated: (controller) => onMapCreated(controller),
      zoomControlsEnabled: false, // Disable the zoom controls
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      tiltGesturesEnabled: false,
      compassEnabled: false,
      mapToolbarEnabled: false,
      mapType: MapType.normal,
    );
  }
}
