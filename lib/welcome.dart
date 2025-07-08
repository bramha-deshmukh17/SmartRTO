import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'officials_page/officer_login.dart';
import 'user_pages/user_register.dart';
import 'utility/constants.dart';
import 'utility/my_card.dart';

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
