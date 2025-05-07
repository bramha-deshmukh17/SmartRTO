import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../utility/appbar.dart';
import '../../utility/constants.dart';
import '../../utility/user_input.dart';
import 'view_application.dart';

class LearnerLicenseList extends StatefulWidget {
  static const String id = 'officer/licenselist';

  const LearnerLicenseList({super.key});

  @override
  State<LearnerLicenseList> createState() => _LearnerLicenseListState();
}

class _LearnerLicenseListState extends State<LearnerLicenseList> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _controller = TextEditingController();

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
    // Fetching the application list from the Firestore
    if (arguments == null) return;

    String type = arguments?['applicationType'] == "LL"
        ? 'llapplication'
        : 'dlapplication';

    // First query: examResult == true
    final resultTrue = await _firestore
        .collection(type)
        .where('approved', isEqualTo: false)
        .where('examResult', isEqualTo: true)
        .get();

    // Second query: examResult == null
    final resultNull = await _firestore
        .collection(type)
        .where('approved', isEqualTo: false)
        .where('examResult', isNull: true)
        .get();

    // Combine both result sets
    final allDocs = [...resultTrue.docs, ...resultNull.docs];

    // Use a map to ensure uniqueness
    final uniqueDocs = <String, Map<String, dynamic>>{};

    for (var doc in allDocs) {
      uniqueDocs[doc.id] = {
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
                              content: Text(
                                  'Please enter a valid application number')),
                        );
                        return;
                      }
                      Navigator.pushNamed(context, ViewApplication.id,
                          arguments: {
                            'applicationId': _controller.text,
                            'applicationType': arguments?['applicationType'],
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
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
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
                                    color: application['approved']
                                        ? kGreen
                                        : kRed),
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
                            Navigator.pushNamed(context, ViewApplication.id,
                                arguments: {
                                  'applicationId': application['applicationId'],
                                  'applicationType':
                                      arguments?['applicationType'],
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
        ));
  }
}
