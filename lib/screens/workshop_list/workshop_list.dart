import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkshopList extends StatefulWidget {
  const WorkshopList({Key? key}) : super(key: key);

  @override
  State<WorkshopList> createState() => _WorkshopListState();
}

class _WorkshopListState extends State<WorkshopList> {
  late Future<List<DocumentSnapshot>> _workshopsFuture;

  @override
  void initState() {
    super.initState();
    _workshopsFuture = _fetchWorkshops();
  }

  Future<List<DocumentSnapshot>> _fetchWorkshops() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('workshops').get();
    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Workshop List',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: _workshopsFuture,
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
            List<DocumentSnapshot> workshops = snapshot.data!;
            return ListView.builder(
              itemCount: workshops.length,
              itemBuilder: (context, index) {
                var workshop = workshops[index].data() as Map<String, dynamic>;
                GeoPoint location = workshop['location'];
                String latitude = location.latitude.toString();
                String longitude = location.longitude.toString();
                String locationString =
                    'Latitude: $latitude, Longitude: $longitude';

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(workshop['name']),
                    subtitle: Text(locationString),
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
