import 'package:drive_guard/constants.dart';
import 'package:drive_guard/screens/home/components/available_workshop.dart';
import 'package:drive_guard/screens/home/components/request_button.dart';
import 'package:flutter/material.dart';

import 'components/user_location.dart';
import 'components/home_header.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const HomeHeader(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
                child: const Divider(
                  color: kSecondaryColor,
                ),
              ),
              const SizedBox(height: 20),
              const UserLocation(),
              const AvailableWorkshop(),
              const SizedBox(height: 20),
              const RequestButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
