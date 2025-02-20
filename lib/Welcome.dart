import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'OfficialsPage/OfficerLogin.dart';
import 'Utility/MyCard.dart';
import 'Utility/Constants.dart';
import 'UserPages/UserRegister.dart';

class Welcome extends StatelessWidget {
  static const String id = 'Welcome';

  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.add,
          color: Colors.transparent,
        ),
        backgroundColor: kPrimaryColor,
        title: kAppBarTitle,
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomCard(
              cardTitle: 'User',
              big: true,
              icon: FontAwesomeIcons.userLarge,
              onTap: () {
                Navigator.pushNamed(context, UserRegister.id);
              },
            ),
            CustomCard(
              cardTitle: 'Officials',
              icon: Icons.local_police,
              big: true,
              onTap: () {
                Navigator.pushNamed(context, OfficerLogin.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
