import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkshopProvider extends ChangeNotifier {
  late List<DocumentSnapshot> _workshops = [];
  late int _workshopCount = 0; // To store the number of workshops

  List<DocumentSnapshot> get workshops => _workshops;
  int get workshopCount => _workshopCount;

  Future<void> fetchWorkshops() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('workshops').get();
      _workshops = snapshot.docs;
      _workshopCount = snapshot.size; // Get the number of documents
      notifyListeners();
    } catch (e) {
      print("Error fetching workshops: $e");
    }
  }
}
