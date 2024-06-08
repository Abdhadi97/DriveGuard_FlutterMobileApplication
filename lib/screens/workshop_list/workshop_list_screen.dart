import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drive_guard/providers/workshop_provider.dart';
import 'package:drive_guard/components/workshop_card.dart';
import 'package:drive_guard/models/workshop.dart';

class WorkshopListScreen extends StatelessWidget {
  const WorkshopListScreen({Key? key});

  static String routeName = "/workshops";

  @override
  Widget build(BuildContext context) {
    final workshopProvider = Provider.of<WorkshopProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Workshops"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FutureBuilder(
            future: workshopProvider.fetchWorkshops(), // Await fetchWorkshops()
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return ListView.builder(
                  itemCount: workshopProvider.workshops.length,
                  itemBuilder: (context, index) {
                    Workshop workshop = workshopProvider.workshops[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: WorkshopCard(
                        imageUrl: workshop.imageUrl,
                        title: workshop.name,
                        onPress: () {},
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
