import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utility/appbar.dart';
import '../../utility/constants.dart';

class ViewPucApplication extends StatefulWidget {
  static const String id = 'officer/puc/application';

  const ViewPucApplication({super.key});

  @override
  _ViewPucApplicationState createState() => _ViewPucApplicationState();
}

class _ViewPucApplicationState extends State<ViewPucApplication> {
  Map<String, dynamic>? applicationData;
  bool isLoading = true;
  Map<String, dynamic>? arguments;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    arguments =
        (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?)!;
    fetchApplicationData();
  }

  Future<void> fetchApplicationData() async {
    //fetch puc application data
    DocumentSnapshot docSnapshot = await _firestore
        .collection('pucapplication')
        .doc(arguments?['applicationId'])
        .get();

    if (docSnapshot.exists) {
      setState(() {
        applicationData = docSnapshot.data() as Map<String, dynamic>?;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        title: 'PUC Application',
        displayOfficerProfile: true,
        isBackButton: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: kSecondaryColor,))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Application ID: ${applicationData?['receiptId']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  kBox,
                  Text(
                    'Full Name: ${applicationData?['fullName']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Mobile: ${applicationData?['mobile']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Pin Code: ${applicationData?['pinCode']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Registration: ${applicationData?['registration']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Chasis: ${applicationData?['chasis']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Selected State: ${applicationData?['selectedState']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Selected District: ${applicationData?['selectedDistrict']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Payment ID: ${applicationData?['paymentId']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Slot ID: ${applicationData?['slot_id']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Slot No: ${applicationData?['slot_no']}',
                    style: TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Created At: ${DateFormat('dd MMMM yyyy, HH:mm:ss').format((applicationData?['createdAt'] as Timestamp).toDate())}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
    );
  }
}
