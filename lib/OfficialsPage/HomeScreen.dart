import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'License/LicenseList.dart';
import '../Utility/Appbar.dart';
import 'Grievance/OfficerGrievanceList.dart';
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
ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        title: 'Home',
        displayOfficerProfile: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Scrollbar(
              controller: _scrollController,
              thumbVisibility: true, // Always show scrollbar
              thickness: 2.0, // Set the scrollbar thickness
              radius: Radius.circular(10), // Make scrollbar edges rounded
              child: SingleChildScrollView(
                controller: _scrollController,
                scrollDirection:
                    Axis.horizontal, // Enables horizontal scrolling
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    
                    CustomCard(
                      icon: FontAwesomeIcons.clipboardList,
                      cardTitle: 'LL Application',
                      onTap: () {
                        Navigator.pushNamed(
                            context, LearnerLicenseList.id, arguments: {'applicationType': 'LL'});
                      },
                    ),
                    CustomCard(
                      icon: FontAwesomeIcons.filePen,
                      cardTitle: 'DL Application',
                      onTap: () {
                        Navigator.pushNamed(context, LearnerLicenseList.id, arguments: {'applicationType': 'DL'});
                      },
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: CustomCard(
                icon: FontAwesomeIcons.car,
                cardTitle: 'Fine',
                onTap: () {
                  Navigator.pushNamed(context, GenerateFines.id);
                },
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: CustomCard(
                icon: Icons.comment,
                cardTitle: 'Vehicle',
                onTap: () {
                  Navigator.pushNamed(context, ViewDetails.id);
                },
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
      )
      
    );
  }
}
