import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utility/appbar.dart';
import '../utility/constants.dart';
import '../utility/my_card.dart';
import 'grievance/grievance_list.dart';
import 'license/license.dart';
import 'puc/puc_application.dart';
import 'vehicle/vehicles.dart';
import 'chatbot/chatbot.dart';
import 'license/phone_authenticate.dart';

class HomePage extends StatefulWidget {
  static const String id = 'user/home';

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
                            context, PhoneAuthenticate.id, arguments: {
                          'driving': false,
                        });
                      },
                    ),
                    CustomCard(
                      icon: FontAwesomeIcons.clipboardList,
                      cardTitle: 'DL Application',
                      onTap: () {
                        Navigator.pushNamed(
                            context, PhoneAuthenticate.id, arguments: {
                          'driving': true,
                        });
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
                icon: FontAwesomeIcons.solidMessage,
                cardTitle: 'Grievance',
                onTap: () {
                  Navigator.pushNamed(context, Grievancelist.id);
                },
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: CustomCard(
                icon: FontAwesomeIcons.clipboardList,
                cardTitle: 'PUC Application',
                onTap: () {
                  Navigator.pushNamed(context, PucApplication.id);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
