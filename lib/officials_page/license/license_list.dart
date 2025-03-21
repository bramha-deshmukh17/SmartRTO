import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../utility/appbar.dart';
import '../../utility/constants.dart';
import 'view_application.dart';

class LearnerLicenseList extends StatefulWidget {
  static const String id = 'officer/licenselist';

  const LearnerLicenseList({super.key});

  @override
  State<LearnerLicenseList> createState() => _LearnerLicenseListState();
}

class _LearnerLicenseListState extends State<LearnerLicenseList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> applicationList = [];
  Map<String, dynamic>? arguments;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    arguments =
        (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?)!;
    fetchApplicationList();
  }

  Future<void> fetchApplicationList() async {
    //fetching the application list from the firestore
    if (arguments == null) return;

    String type = arguments?['applicationType'] == "LL"
        ? 'llapplication'
        : 'dlapplication';
        //fetching the only non approved application list from the firestore
    final approvedFalseSnapshot = await _firestore
        .collection(type)
        .where('approved', isEqualTo: false)
        .get();


    // Use a set to track unique document IDs
    final uniqueDocs = <String, Map<String, dynamic>>{};

    for (var doc in approvedFalseSnapshot.docs) {
      uniqueDocs[doc.id] = {
        //adding doc id to the application data for further use
        'applicationId': doc.id,
        'approved': doc['approved'],
        'examResult': doc['examResult'],
      };
    }

    setState(() {
      applicationList = uniqueDocs.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        title: arguments?['applicationType'] == "LL"
            ? 'Lerner License Application List'
            : 'Driving License Application List',
        isBackButton: true,
        displayOfficerProfile: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: applicationList.length,
              itemBuilder: (context, index) {
                final application = applicationList[index];
                return Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  child: Card(
                    child: ListTile(
                      title: Text(
                        'Application ID: ${application['applicationId']}',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Verification: ${application['approved'] ? "Approved" : "Under Scrutiny"}',
                            style: TextStyle(
                                fontSize: 18,
                                color: application['approved'] ? kGreen : kRed),
                          ),
                          Text(
                            'Exam Result: ${application['examResult'] == null ? "N/A" : application['examResult'] ? "Passed" : "Failed"}',
                            style: TextStyle(
                              fontSize: 18,
                              color: application['examResult'] == null
                                  ? kRed
                                  : application['examResult']
                                      ? kGreen
                                      : kRed,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        // navigat to the view application page
                        Navigator.pushNamed(context, ViewApplication.id, arguments: {
                          'applicationId': application['applicationId'],
                          'applicationType': arguments?['applicationType'],
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
