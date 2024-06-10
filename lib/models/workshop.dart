import 'package:cloud_firestore/cloud_firestore.dart';

class Workshop {
  final String name;
  final GeoPoint location;
  final String imageUrl;

  Workshop({
    required this.name,
    required this.location,
    required this.imageUrl,
  });

  factory Workshop.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Workshop(
      name: data['name'] ?? '',
      location: data['location'] ?? GeoPoint(0, 0),
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}
