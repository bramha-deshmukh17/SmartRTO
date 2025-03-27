import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utility/appbar.dart';
import '../../utility/constants.dart';
import '../../utility/user_input.dart';
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
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchApplicationList();
  }

  Future<void> fetchApplicationList() async {
    //fetch puc application list
    final snapshot = await _firestore.collection('pucapplication').get();

    // Use a set to track unique document IDs
    final uniqueDocs = <String, Map<String, dynamic>>{};

    for (var doc in snapshot.docs) {
      uniqueDocs[doc.id] = {
        //add doc id in the data for future use
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
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: UserInput(
                    controller: _controller,
                    hint: 'Enter Application Number',
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (_controller.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: kRed,
                          content:
                              Text('Please enter a valid application number'),
                        ),
                      );
                      return;
                    }
                    Navigator.pushNamed(context, ViewPucApplication.id,
                        arguments: {
                          'applicationId': _controller.text,
                        });
                  },
                  icon: Icon(FontAwesomeIcons.search),
                ),
              ],
            ),
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
      ),
    );
  }
}
