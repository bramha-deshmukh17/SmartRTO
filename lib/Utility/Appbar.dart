import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../OfficialsPage/OfficerProfile.dart';
import '../UserPages/Profile/UserProfile.dart';
import 'Constants.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBackButton;
  final bool displayUserProfile;
  final bool displayOfficerProfile;

  const Appbar({
    required this.title,
    this.displayUserProfile = false,
    this.displayOfficerProfile = false,
    this.isBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kPrimaryColor,
      leading: isBackButton
          ? IconButton(
              icon: kBackArrow,
              onPressed: () {
                Navigator.pop(context);
              },
            )
          : const SizedBox(
              width: 5.0,
            ),
      title: Text(
        title,
        style: const TextStyle(
          color: kWhite,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        if (displayUserProfile)
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, UserProfile.id);
            },
            icon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: const Icon(
                FontAwesomeIcons.userLarge,
                color: kWhite,
              ),
            ),
          ),
        if (displayOfficerProfile)
          IconButton(
            icon: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Icon(
                FontAwesomeIcons.userLarge,
                color: kWhite,
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, Profile.id);
            },
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50.0);
}
