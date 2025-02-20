import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Utility/Appbar.dart';
import '/OfficialsPage/Grievance/OfficerGrievanceList.dart';
import '/Utility/MyCard.dart';
import 'Fine/GenerateFine.dart';
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
              onTap: () {
                Navigator.pushNamed(context, GenerateFines.id);
              },
              cardTitle: 'Fine',
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: CustomCard(
              icon: FontAwesomeIcons.car,
              onTap: () {
                Navigator.pushNamed(context, ViewDetails.id);
              },
              cardTitle: 'Vehicles',
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: CustomCard(
              icon: Icons.message,
              onTap: () {
                Navigator.pushNamed(context, OfficerGrievanceList.id);
              },
              cardTitle: 'Grievances',
            ),
          ),
        ],
      ),
    );
  }
}
