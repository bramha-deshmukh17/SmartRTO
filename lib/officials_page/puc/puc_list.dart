import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utility/appbar.dart';
import 'puc_application.dart';

class PucList extends StatefulWidget {
  static const String id = 'officer/puc/list';

  const PucList({super.key});
  @override
  _PucListState createState() => _PucListState();
}

class _PucListState extends State<PucList> {
  List<Map<String, dynamic>> applicationList = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    fetchApplicationList();
  }

  Future<void> fetchApplicationList() async {
    final snapshot = await _firestore.collection('pucapplication').get();

    // Use a set to track unique document IDs
    final uniqueDocs = <String, Map<String, dynamic>>{};

    for (var doc in snapshot.docs) {
      uniqueDocs[doc.id] = {
        'applicationId': doc['receiptId'],
        'registrationNo': doc['registration'],
        'fullName': doc['fullName'],
      };
    }

    setState(() {
      applicationList = uniqueDocs.values.toList();
      print(applicationList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        title: 'PUC List',
        displayOfficerProfile: true,
        isBackButton: true,
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
                            'Registration Number: ${application['registrationNo']}',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            'Full Name: ${application['fullName']}',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                         Navigator.pushNamed(context, ViewPucApplication.id,
                           arguments: {
                            'applicationId': application['applicationId'],
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
