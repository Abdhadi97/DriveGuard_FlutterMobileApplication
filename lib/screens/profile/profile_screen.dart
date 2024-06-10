import 'package:drive_guard/constants.dart';
import 'package:drive_guard/screens/profile/components/update_profile_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../init_screen.dart';
import '../sign_in/sign_in_screen.dart';
import 'components/profile_menu.dart';
import 'components/profile_pic.dart';

class ProfileScreen extends StatefulWidget {
  static String routeName = "/profile";

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchUserData();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Account',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: kSecondaryColor,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, InitScreen.routeName);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: kSecondaryColor,
          ),
        ),
        leadingWidth: 80,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            vertical: screenWidth * 0.05, horizontal: screenHeight * 0.005),
        child: Column(
          children: [
            ProfilePic(),
            SizedBox(height: screenHeight * 0.02),
            Consumer<UserProvider>(
              builder: (context, userProvider, _) {
                if (userProvider.user != null) {
                  return Column(
                    children: [
                      Text(
                        '${userProvider.user!.firstName} ${userProvider.user!.lastName}'
                            .toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenHeight * 0.03),
                        child: Divider(
                          thickness: 2,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          const Icon(
                            Icons.mail_outlined,
                            color: kSecondaryColor,
                          ),
                          Text(
                            ' ${userProvider.user?.email}',
                            style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                color: kSecondaryColor),
                          ),
                          const Spacer(),
                        ],
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          const Icon(
                            Icons.phone_outlined,
                            color: kSecondaryColor,
                          ),
                          Text(
                            ' ${userProvider.user?.phoneNum}',
                            style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                color: kSecondaryColor),
                          ),
                          const Spacer(),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenHeight * 0.03),
                        child: Divider(
                          thickness: 2,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            ProfileMenu(
              text: "Edit Detail",
              icon: "assets/icons/User Icon.svg",
              press: () async {
                final updatedData = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileUpdate()),
                );
                if (updatedData != null) {
                  await _updateProfile(userProvider, updatedData);
                }
              },
            ),
            ProfileMenu(
              text: "User Guide",
              icon: "assets/icons/book-svgrepo-com.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Account Deletion",
              icon: "assets/icons/delete-forever.svg",
              press: () async {
                final userProvider =
                    Provider.of<UserProvider>(context, listen: false);
                bool confirmDelete = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    surfaceTintColor: Colors.white,
                    backgroundColor: Colors.white,
                    shadowColor: Colors.black,
                    title: const Text(
                      "Account Deletion?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: const Text(
                        "Are you sure you want to delete your account? This action cannot be undone."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text(
                          "Delete",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );

                if (confirmDelete == true) {
                  await userProvider.deleteUser();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignInScreen(),
                    ),
                  );
                }
              },
            ),
            ProfileMenu(
              text: "Log Out",
              icon: "assets/icons/Log out.svg",
              press: () {
                userProvider.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignInScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateProfile(
      UserProvider userProvider, Map<String, dynamic> data) async {
    try {
      await userProvider.updateUserProfile(
        data['firstname'],
        data['lastname'],
        data['phoneNum'],
      );
    } catch (e) {
      // Handle errors, for example show a snackbar or dialog
      print('Error updating profile: $e');
    }
  }
}

class UserInfoSection extends StatelessWidget {
  const UserInfoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Column(
      children: [
        if (userProvider.user != null)
          Text(
            '${userProvider.user!.firstName} ${userProvider.user!.lastName}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        const SizedBox(height: 10),
        // Add other user information widgets here
      ],
    );
  }
}

class ProfileUpdate extends StatelessWidget {
  ProfileUpdate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    String? email = userProvider.user?.email;
    String? password = userProvider.user?.pass;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Detail',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: kSecondaryColor,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: kSecondaryColor,
          ),
        ),
        leadingWidth: 80,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.01),
                  const Text("Current User", style: headingStyle),
                  SizedBox(height: screenHeight * 0.01),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Divider(
                      color: Colors.grey.withOpacity(0.5),
                      thickness: 2,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  _buildUserInfoRow(Icons.email, "Email: ", email ?? 'N/A'),
                  const SizedBox(height: 8),
                  _buildUserInfoRow(
                      Icons.lock, "Password: ", password ?? 'N/A'),
                  SizedBox(height: screenHeight * 0.01),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Divider(
                      color: Colors.grey.withOpacity(0.5),
                      thickness: 2,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.06),
                  const UpdateProfileForm(),
                  const SizedBox(height: 30),
                  Text(
                    "By continuing, you confirm that you agree \nwith our Terms and Conditions.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        const Spacer(),
        Icon(
          icon,
          size: 24,
          color: Colors.black54,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16),
        ),
        const Spacer(),
      ],
    );
  }
}
