import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utility/appbar.dart';
import '../utility/my_card.dart';
import 'fines/modify_fine_info.dart';
import 'license/license_list.dart';
import 'grievance/view_grievances.dart';
import 'fines/generate_fine.dart';
import 'fines/view_details.dart';
import 'puc/puc_list.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'officer/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController2 = ScrollController();

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
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'License Application',
                style: TextStyle(fontSize: 18.0),
              ),
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
                          Navigator.pushNamed(context, LearnerLicenseList.id,
                              arguments: {'applicationType': 'LL'});
                        },
                      ),
                      CustomCard(
                        icon: FontAwesomeIcons.clipboardList,
                        cardTitle: 'DL Application',
                        onTap: () {
                          Navigator.pushNamed(context, LearnerLicenseList.id,
                              arguments: {'applicationType': 'DL'});
                        },
                      ),
                    ],
                  ),
                ),
              ),

              Text(
                'Fine and grievance',
                style: TextStyle(fontSize: 18.0),
              ),
              Scrollbar(
                controller: _scrollController2,
                thumbVisibility: true, // Always show scrollbar
                thickness: 2.0, // Set the scrollbar thickness
                radius: Radius.circular(10), // Make scrollbar edges rounded
                child: SingleChildScrollView(
                  controller: _scrollController2,
                  scrollDirection:
                      Axis.horizontal, // Enables horizontal scrolling
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      CustomCard(
                        icon: FontAwesomeIcons.ticket,
                        cardTitle: 'Fine',
                        onTap: () {
                          Navigator.pushNamed(context, GenerateFines.id);
                        },
                      ),
                      CustomCard(
                        icon: FontAwesomeIcons.filePen,
                        cardTitle: 'Fine Data',
                        onTap: () {
                          Navigator.pushNamed(context, ModifyFineData.id);
                        },
                      ),
                      CustomCard(
                        icon: FontAwesomeIcons.car,
                        cardTitle: 'Vehicle',
                        onTap: () {
                          Navigator.pushNamed(context, ViewDetails.id);
                        },
                      ),
                      CustomCard(
                        icon: FontAwesomeIcons.solidMessage,
                        onTap: () {
                          Navigator.pushNamed(context, OfficerGrievanceList.id);
                        },
                        cardTitle: 'Grievances',
                      ),
                    ],
                  ),
                ),
              ),

              Text(
                'PUC Appointment',
                style: TextStyle(fontSize: 18.0),
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: CustomCard(
                  icon: FontAwesomeIcons.clipboardList,
                  onTap: () {
                    Navigator.pushNamed(context, PucList.id);
                  },
                  cardTitle: 'PUC Appointment',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
