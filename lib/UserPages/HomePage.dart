import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Utility/Appbar.dart';
import '/UserPages/Grievance/GrievanceList.dart';
import '/UserPages/LicenseInfoPage.dart';
import '/UserPages/Profile/UserProfile.dart';
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
  @override
  void initState(){
    super.initState();

    Future.microtask(() {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: kPrimaryColor),
      );
    });
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reset the status bar color every time dependencies change
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: kPrimaryColor),
    );
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
        child: const Icon(FontAwesomeIcons.robot, color: kWhite,),
      ),
      appBar: Appbar(
        title: 'Home',
        displayUserProfile: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

          Align(
            alignment: Alignment.center,
            child: CustomCard(
              icon: FontAwesomeIcons.driversLicense,
              cardTitle: 'My License',
              button1: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, LicenseInfoPage.id);
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
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: CustomCard(
              icon: FontAwesomeIcons.car,
              cardTitle: 'My Vehicles',
              button1: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, ViewVehicle.id);
                  },
                  child: const Text(
                    'View',
                    style: TextStyle(
                      color: kSecondaryColor,
                      fontSize: 18,
                      fontFamily: 'InriaSans',
                    ),
                  )),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: CustomCard(
              icon: Icons.comment,
              cardTitle: 'Grievance',
              button1: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, Grievancelist.id);
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
            ),
          ),
        ],
      ),
    );
  }
}
