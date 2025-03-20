import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utility/appbar.dart';
import '../utility/constants.dart';
import '../utility/my_card.dart';
import 'grievance/grievance_list.dart';
import 'license/license.dart';
import 'license/track_application.dart';
import 'puc/phone_authentication.dart';
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
  final ScrollController _scrollController1 = ScrollController();
  final ScrollController _scrollController2 = ScrollController();

  @override
  void dispose() {
    _scrollController1.dispose();
    _scrollController2.dispose();
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
            // First horizontal scroll view using _scrollController1
            Scrollbar(
              controller: _scrollController1,
              thumbVisibility: true,
              thickness: 2.0,
              radius: const Radius.circular(10),
              child: SingleChildScrollView(
                controller: _scrollController1,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    CustomCard(
                      icon: FontAwesomeIcons.idCard,
                      cardTitle: 'License',
                      onTap: () {
                        Navigator.pushNamed(context, LicenseInfoPage.id);
                      },
                    ),
                    CustomCard(
                      icon: FontAwesomeIcons.listCheck,
                      cardTitle: 'Track Application',
                      onTap: () {
                        Navigator.pushNamed(context, TrackApplication.id);
                      },
                    ),
                    CustomCard(
                      icon: FontAwesomeIcons.clipboardList,
                      cardTitle: 'LL Application',
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          PhoneAuthenticate.id,
                          arguments: {'driving': false},
                        );
                      },
                    ),
                    CustomCard(
                      icon: FontAwesomeIcons.clipboardList,
                      cardTitle: 'DL Application',
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          PhoneAuthenticate.id,
                          arguments: {'driving': true},
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Second horizontal scroll view using _scrollController2
            Scrollbar(
              controller: _scrollController2,
              thumbVisibility: true,
              thickness: 2.0,
              radius: const Radius.circular(10),
              child: SingleChildScrollView(
                controller: _scrollController2,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    CustomCard(
                      icon: FontAwesomeIcons.car,
                      cardTitle: 'My Vehicles',
                      onTap: () {
                        Navigator.pushNamed(context, ViewVehicle.id);
                      },
                    ),
                    CustomCard(
                      icon: FontAwesomeIcons.solidMessage,
                      cardTitle: 'Grievance',
                      onTap: () {
                        Navigator.pushNamed(context, Grievancelist.id);
                      },
                    ),
                  ],
                ),
              ),
            ),

            Align(
              alignment: Alignment.center,
              child: CustomCard(
                icon: FontAwesomeIcons.clipboardList,
                cardTitle: 'PUC Application',
                onTap: () {
                  Navigator.pushNamed(context, PhoneAuthentication.id);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
