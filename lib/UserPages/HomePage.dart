import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_rto/UserPages/Grievance/GenerateGrievance.dart';
import 'package:smart_rto/UserPages/Grievance/GrievanceList.dart';
import 'package:smart_rto/UserPages/LicenseInfoPage.dart';
import 'package:smart_rto/UserPages/Profile/UserProfile.dart';
import 'package:smart_rto/UserPages/Vehicle/Vehicles.dart';
import 'package:smart_rto/Utility/MyCard.dart';
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
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        leading: const SizedBox(
          width: 5.0,
        ),
        title: kAppBarTitle,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, UserProfile.id);
            },
            icon: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Icon(
                FontAwesomeIcons.userLarge,
                color: kWhite,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, Grievancelist.id);
            },
            child: const Text(
              'Grievance',
              style: TextStyle(
                color: kSecondaryColor,
                fontSize: 18,
                fontFamily: 'InriaSans',
              ),
            ),
          ),
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
          )
        ],
      ),
    );
  }
}
