import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Personal Detail'),
              Tab(text: 'Vehicle Detail'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PersonalDetailTab(),
            VehicleDetailTab(),
          ],
        ),
      ),
    );
  }
}

class PersonalDetailTab extends StatelessWidget {
  const PersonalDetailTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'First Name'),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Last Name'),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Phone Number'),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Address'),
          ),
        ],
      ),
    );
  }
}

class VehicleDetailTab extends StatelessWidget {
  const VehicleDetailTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            items: [
              DropdownMenuItem(
                child: Text('Car'),
                value: 'car',
              ),
              DropdownMenuItem(
                child: Text('Motorcycle'),
                value: 'motorcycle',
              ),
            ],
            onChanged: (value) {},
            decoration: InputDecoration(labelText: 'Vehicle Type'),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Model Name'),
          ),
        ],
      ),
    );
  }
}
