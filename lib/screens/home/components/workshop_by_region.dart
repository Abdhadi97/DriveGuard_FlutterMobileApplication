import 'package:flutter/material.dart';
import '../../products/products_screen.dart';
import 'section_title.dart';

class WorkshopByRegion extends StatelessWidget {
  const WorkshopByRegion({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
            title: "Available Workshop",
            press: () {},
          ),
        ),
        SizedBox(
          height: screenHeight * 0.15,
          width: screenWidth * 0.93, // Adjust height as needed
          child: PageView(
            controller: PageController(viewportFraction: 1),
            children: [
              WorkshopCard(
                image: "assets/images/Image Banner 2.png",
                category: "Bidor",
                numOfWorkshop: 18,
                press: () {
                  Navigator.pushNamed(context, ProductsScreen.routeName);
                },
              ),
              WorkshopCard(
                image: "assets/images/Image Banner 3.png",
                category: "Tapah",
                numOfWorkshop: 24,
                press: () {
                  Navigator.pushNamed(context, ProductsScreen.routeName);
                },
              ),
              WorkshopCard(
                image: "assets/images/Image Banner 3.png",
                category: "Teluk Intan",
                numOfWorkshop: 24,
                press: () {
                  Navigator.pushNamed(context, ProductsScreen.routeName);
                },
              ),
            ],
          ),
        ),
      ],
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
  final int numOfWorkshop;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 10, right: 13), // Adjust padding as needed
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: MediaQuery.of(context).size.width *
              0.75, // Adjust width as needed
          height: 100,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Image.asset(
                  image,
                  fit: BoxFit.cover,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  child: Text.rich(
                    TextSpan(
                      style: const TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: "$category\n",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: "$numOfWorkshop Brands")
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
