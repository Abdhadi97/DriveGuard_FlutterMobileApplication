import 'package:drive_guard/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/workshop_provider.dart';

class WorkshopList extends StatelessWidget {
  const WorkshopList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final workshopProvider =
        Provider.of<WorkshopProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Workshop List',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: kSecondaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: workshopProvider.fetchWorkshops(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<DocumentSnapshot> workshops = workshopProvider.workshops;
            return ListView.builder(
              itemCount: workshops.length,
              itemBuilder: (context, index) {
                var workshop = workshops[index].data() as Map<String, dynamic>;
                GeoPoint location = workshop['location'];
                String latitude = location.latitude.toString();
                String longitude = location.longitude.toString();
                String locationString =
                    'Latitude: $latitude, Longitude: $longitude';
                String imageUrl =
                    workshop['imageUrl'] ?? ''; // Retrieve imageUrl

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(workshop['name']),
                    subtitle: Text(locationString),
                    leading: imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl) // Load image if imageUrl is available
                        : const SizedBox(), // Use SizedBox if no imageUrl
                    // Add more details if needed
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
