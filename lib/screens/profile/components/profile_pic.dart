import 'dart:io';

import 'package:drive_guard/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_provider.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePic extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.user;
        return SizedBox(
          height: 130,
          width: 130,
          child: Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.none,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: kSecondaryColor,
                    width: 2,
                  ), // Adjust border properties as needed
                ),
                child: CircleAvatar(
                  backgroundImage: (user != null &&
                          user.imageUrl != null &&
                          user.imageUrl!.isNotEmpty)
                      ? NetworkImage(user.imageUrl!)
                      : const AssetImage("assets/images/Profile Image.png")
                          as ImageProvider,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                        side: const BorderSide(color: Colors.transparent),
                      ),
                      backgroundColor: kPrimaryColor,
                    ),
                    onPressed: () => _pickImage(context),
                    child: SvgPicture.asset(
                      "assets/icons/change-record-type.svg",
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.updateUserProfileImage(File(pickedFile.path));
    }
  }
}
