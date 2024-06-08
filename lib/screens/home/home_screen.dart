import 'package:drive_guard/screens/home/components/workshop_by_region.dart';
import 'package:flutter/material.dart';

import 'components/user_location.dart';
import 'components/home_header.dart';
import 'components/popular_product.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 16),
          child: Column(
            children: [
              HomeHeader(),
              UserLocation(),
              WorkshopByRegion(),
              SizedBox(height: 20),
              PopularProducts(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
