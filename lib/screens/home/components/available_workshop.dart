import 'package:flutter/material.dart';
import 'package:drive_guard/providers/workshop_provider.dart';
import 'package:provider/provider.dart';
import 'section_title.dart';

class AvailableWorkshop extends StatelessWidget {
  const AvailableWorkshop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Consumer<WorkshopProvider>(
      builder: (context, workshopProvider, _) {
        workshopProvider.fetchWorkshops();

        if (workshopProvider.workshops.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final workshopData = workshopProvider.workshopCount;

        return Column(
          children: [
            SizedBox(height: screenHeight * 0.02),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SectionTitle(
                title: "Available Workshop",
                press: () {},
                buttonText: '',
              ),
            ),
            SizedBox(
              height: screenHeight * 0.2, // Adjust height as needed
              width: screenWidth * 0.95,
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: workshopProvider.workshops.length,
                itemBuilder: (context, index) {
                  final workshop = workshopProvider.workshops[index];
                  final workshopData = workshop.data() as Map<String, dynamic>;
                  final imageUrl = workshopData['imageUrl'] ??
                      'assets/images/Image Banner 2.png';
                  final name = workshopData['name'] ?? 'No Name';

                  return WorkshopCard(
                    image: imageUrl,
                    category: name,
                    numOfWorkshop: '', // No need for number in each card
                    press: () {
                      // Handle on press if needed
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
              child: Row(
                children: [
                  const Spacer(),
                  Text(
                    "Total Workshops: $workshopData",
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class WorkshopCard extends StatelessWidget {
  const WorkshopCard({
    Key? key,
    required this.category,
    required this.image,
    required this.numOfWorkshop,
    required this.press,
  }) : super(key: key);

  final String category, image;
  final String numOfWorkshop;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.only(
            left: 10, right: 13), // Adjust padding as needed
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Image.network(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black54,
                      Colors.black38,
                      Colors.black26,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Text(
                  category,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
