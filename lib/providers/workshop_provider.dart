import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_guard/models/workshop.dart';

class WorkshopProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Workshop> _workshops = [];

  List<Workshop> get workshops => _workshops;

  // Fetch workshops from Firestore
  Future<void> fetchWorkshops() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('workshops').get();
      _workshops =
          querySnapshot.docs.map((doc) => Workshop.fromFirestore(doc)).toList();
      notifyListeners();
    } catch (e) {
      print("Error fetching workshops: $e");
    }
  }
}
