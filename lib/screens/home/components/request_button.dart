import 'package:drive_guard/screens/map/open_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'section_title.dart';

class RequestButton extends StatelessWidget {
  const RequestButton({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      child: Column(
        children: [
          SectionTitle(
            title: "Need an Assistance?",
            press: () {},
            buttonText: "",
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, OpenMapScreen.routeName);
            },
            child: const Row(
              children: [
                Spacer(),
                Icon(Icons.search),
                Text(
                  "Click Here",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
