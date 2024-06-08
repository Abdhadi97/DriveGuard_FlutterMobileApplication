import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkshopProvider extends ChangeNotifier {
  late List<DocumentSnapshot> _workshops = [];

  List<DocumentSnapshot> get workshops => _workshops;

  Future<void> fetchWorkshops() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('workshops').get();
      _workshops = snapshot.docs;
      notifyListeners();
    } catch (e) {
      print("Error fetching workshops: $e");
    }
  }
}
