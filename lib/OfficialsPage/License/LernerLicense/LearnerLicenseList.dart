import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'ViewApplication.dart';
import '../../../Utility/Appbar.dart';
import '../../../Utility/Constants.dart';

class LearnerLicenseList extends StatefulWidget {
  static const String id = 'LearnerLicenseList';

  const LearnerLicenseList({super.key});

  @override
  State<LearnerLicenseList> createState() => _LearnerLicenseListState();
}

class _LearnerLicenseListState extends State<LearnerLicenseList> {
  List<Map<String, dynamic>> applicationList = [];

  Future<void> fetchApplicationList() async {
    final approvedFalseSnapshot = await FirebaseFirestore.instance
        .collection('llapplication')
        .where('approved', isEqualTo: false)
        .get();

    final examResultFalseSnapshot = await FirebaseFirestore.instance
        .collection('llapplication')
        .where('examResult', isEqualTo: false)
        .get();

    // Combine both lists and remove duplicates
    final allDocs = [
      ...approvedFalseSnapshot.docs,
      ...examResultFalseSnapshot.docs,
    ];

    // Use a set to track unique document IDs
    final uniqueDocs = <String, Map<String, dynamic>>{};

    for (var doc in allDocs) {
      uniqueDocs[doc.id] = {
        'applicationId': doc.id,
        'approved': doc['approved'],
        'examResult': doc['examResult'],
        'marks': doc['marks'],
      };
    }

    setState(() {
      applicationList = uniqueDocs.values.toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchApplicationList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        title: 'Learner License Application List',
        isBackButton: true,
        displayOfficerProfile: true,
      ),
      body: ListView.builder(
        itemCount: applicationList.length,
        itemBuilder: (context, index) {
          final application = applicationList[index];
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Card(
              child: ListTile(
                title: Text(
                  'Application ID: ${application['applicationId']}',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                    Text('Exam Result: ${application['examResult'] ?? 'N/A'}',
                        style: TextStyle(
                            fontSize: 18,
                            color: application['approved'] ? kGreen : kRed)),
                    Text(
                      'Marks: ${application['marks'] ?? 'N/A'}',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewApplication(
                        applicationId: application['applicationId'],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
