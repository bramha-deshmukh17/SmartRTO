import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Utility/Appbar.dart';
import '/UserPages/Grievance/GrievanceList.dart';
import 'License/LearnerApplication.dart';
import 'License/LicenseInfoPage.dart';
import '/UserPages/Vehicle/Vehicles.dart';
import '/Utility/MyCard.dart';
import './Chatbot/chatbot.dart';
import '../Utility/Constants.dart';

class HomePage extends StatefulWidget {
  static const String id = 'Homepage';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      floatingActionButton: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kSecondaryColor,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(20),
        ),
        onPressed: () {
          Navigator.pushNamed(context, ChatBot.id);
        },
        child: const Icon(
          FontAwesomeIcons.robot,
          color: kWhite,
        ),
      ),
      appBar: Appbar(
        title: 'Home',
        displayUserProfile: true,
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
                      icon: FontAwesomeIcons.driversLicense,
                      cardTitle: 'License',
                      onTap: () {
                        Navigator.pushNamed(context, LicenseInfoPage.id);
                      },
                    ),
                    CustomCard(
                      icon: FontAwesomeIcons.clipboardList,
                      cardTitle: 'LL Application',
                      onTap: () {
                        Navigator.pushNamed(
                            context, LearnerLicenseApplication.id);
                      },
                    ),
                    CustomCard(
                      icon: FontAwesomeIcons.filePen,
                      cardTitle: 'License Application',
                      onTap: () {
                        Navigator.pushNamed(context, LicenseInfoPage.id);
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
                cardTitle: 'My Vehicles',
                onTap: () {
                  Navigator.pushNamed(context, ViewVehicle.id);
                },
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: CustomCard(
                icon: Icons.comment,
                cardTitle: 'Grievance',
                onTap: () {
                  Navigator.pushNamed(context, Grievancelist.id);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
