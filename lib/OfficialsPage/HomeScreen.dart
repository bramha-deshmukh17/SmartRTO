import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Utility/Appbar.dart';
import '/OfficialsPage/Grievance/OfficerGrievanceList.dart';
import '/Utility/MyCard.dart';
import '../Utility/Constants.dart';
import 'Fine/GenerateFine.dart';
import 'OfficerProfile.dart';
import 'Fine/ViewDetails.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'HomeScreen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        title: 'Home',
        displayOfficerProfile: true,
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
                    fontFamily: 'InriaSans',
                  ),
                ),
              ),
              cardTitle: 'Fine',
              cardDescription: '',
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: CustomCard(
              icon: FontAwesomeIcons.car,
              button1: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, ViewDetails.id);
                },
                child: const Text(
                  'View',
                  style: TextStyle(
                    color: kSecondaryColor,
                    fontSize: 18,
                    fontFamily: 'InriaSans',
                  ),
                ),
              ),
              cardTitle: 'Details',
              cardDescription: '',
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: CustomCard(
              icon: Icons.message,
              button1: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, OfficerGrievanceList.id);
                },
                child: const Text(
                  'View',
                  style: TextStyle(
                    color: kSecondaryColor,
                    fontSize: 18,
                    fontFamily: 'InriaSans',
                  ),
                ),
              ),
              cardTitle: 'Grievances',
              cardDescription: '',
            ),
          ),
        ],
      ),
    );
  }
}
