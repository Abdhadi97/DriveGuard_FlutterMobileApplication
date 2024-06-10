import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/workshop_provider.dart';

class WorkshopDetailScreen extends StatelessWidget {
  static const routeName = '/workshop-details';

  @override
  Widget build(BuildContext context) {
    final workshopProvider = Provider.of<WorkshopProvider>(context);
    final workshops = workshopProvider.workshops;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workshops'),
      ),
      body: PageView.builder(
        itemCount: workshops.length,
        itemBuilder: (context, index) {
          final workshop = workshops[index];
          final workshopData = workshop.data() as Map<String, dynamic>;

          return Stack(
            fit: StackFit.expand,
            children: [
              workshopData['imageUrl'] != null
                  ? Image.network(
                      workshopData['imageUrl'],
                      fit: BoxFit.cover,
                    )
                  : Container(color: Colors.grey),
              Positioned(
                bottom: 20,
                left: 20,
                child: Text(
                  workshopData['name'] ?? 'No Name',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    backgroundColor: Colors.black54,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
