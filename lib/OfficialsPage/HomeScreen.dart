import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_rto/Utility/MyCard.dart';

import '../Utility/Constants.dart';
import '../Welcome.dart';
import 'GenerateFine.dart';
import 'OfficerProfile.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'HomeScreen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: const SizedBox(width: 10.0,),
          backgroundColor: kPrimaryColor,
          title: kAppBarTitle,
          actions: [
            IconButton(
              onPressed: (){
                Navigator.pushNamed(context, Profile.id);
              },
              icon: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Icon(
                    Icons.person,
                    color: kWhite,
                  )),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Align(
              alignment: Alignment.center,
              child: CustomCard(
                icon: FontAwesomeIcons.ticket,
                button1: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, GenerateFines.id);
                  },
                  child: const Text(
                    'Generate',
                    style: TextStyle(
                      color: kSecondaryColor,
                      fontSize: 18,
                    ),
                  ),
                ),
                cardTitle: 'Generate Fine',
                cardDescription: '',
              ),
            ),
            /* Align(
              alignment: Alignment.center,
              child: CustomCard(
                icon: FontAwesomeIcons.ticket,
                button1:  TextButton(
                  onPressed: () {
                    //Navigator.pushNamed(context, '');
                  },
                  child: const Text(
                    'Generate',
                    style: TextStyle(
                      color: kSecondaryColor,
                      fontSize: 18,
                    ),
                  ),
                ),
                cardTitle: 'Generate Fine',
                cardDescription: '',
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
