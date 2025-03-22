import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utility/appbar.dart';
import '../../utility/constants.dart';
import '../vehicle/payment_page.dart';

class Grievancelist extends StatefulWidget {
  static const String id = "user/grievancelist";
  const Grievancelist({super.key});

  @override
  State<Grievancelist> createState() => _GrievancelistState();
}

class _GrievancelistState extends State<Grievancelist> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String userPhone;

  @override
  void initState() {
    super.initState();
    userPhone =
        _auth.currentUser!.phoneNumber ?? ''; // Get the current user's phone
  }

  Stream<QuerySnapshot> _getGrievance() {
    //getting all the grievance made by the user
    return _firestore
        .collection('grievance')
        .where('by',
            isEqualTo: userPhone) // Assuming 'contact' stores user phone
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        title: 'Grievances',
        isBackButton: true,
        displayUserProfile: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _getGrievance(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: kSecondaryColor,
              ));
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Error loading Grievance.'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No Grievances found.'));
            }

            // Display the list of grievance
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var doc = snapshot.data!.docs[index];
                var grievance = doc.data() as Map<String, dynamic>;

                return Card(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      kBox,
                      ListTile(
                        leading: const Icon(FontAwesomeIcons.ticket),
                        title: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PaymentPage(fineid: grievance['fineno']),
                                ),
                              );
                            },
                            child: Center(
                                child: Text(
                              grievance['fineno'],
                              style: TextStyle(color: kBlack),
                            ))),
                      ),
                      ListTile(
                        leading: const Icon(FontAwesomeIcons.comment),
                        title: Center(child: Text(grievance['grievance'])),
                      ),
                      kBox,
                      ListTile(
                        leading: const Icon(FontAwesomeIcons.reply),
                        title: Center(
                          child: grievance['reply'] != 'NA'
                              ? Text(grievance['reply'])
                              : const Text('No Reply'),
                        ),
                      ),
                      kBox,
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
