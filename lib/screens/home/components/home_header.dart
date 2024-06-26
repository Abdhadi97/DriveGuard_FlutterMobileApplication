import 'package:drive_guard/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_provider.dart';
import 'icon_btn_with_counter.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({Key? key}) : super(key: key);

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.user;

        return SizedBox(
          height: screenHeight * 0.08,
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (user != null) ...[
                  Expanded(
                    child: Text(
                      'Hello, ${user.firstName} ${user.lastName}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  IconBtnWithCounter(
                    svgSrc: "assets/icons/Conversation.svg",
                    numOfitem: 3,
                    press: () {},
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, ProfileScreen.routeName);
                    },
                    child: CircleAvatar(
                      backgroundImage: user.imageUrl != null
                          ? NetworkImage(user.imageUrl!)
                          : const AssetImage('assets/default_avatar.png')
                              as ImageProvider,
                      radius: 20, // Adjust the radius as per your need
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
