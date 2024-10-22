import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_rto/Welcome.dart';

import '../Utility/Constants.dart';
import '../Utility/UserInput.dart';
import 'OfficerProfile.dart';

class ViewDetails extends StatefulWidget {
  static const String id = "ViewDetails";

  const ViewDetails({super.key});

  @override
  State<ViewDetails> createState() => _ViewDetailsState();
}

class _ViewDetailsState extends State<ViewDetails> {
  bool _visible = false, loading = false;
  String? formatedNumberPlate, carNoError;
  Map<String, dynamic>? carDetails;
  List<Map<String, dynamic>> fineHistory = [];

  final _auth = FirebaseAuth.instance;
  final TextEditingController carController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: kAppBarTitle,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: kBackArrow,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, Profile.id);
            },
            icon: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Icon(
                Icons.person,
                color: kWhite,
              ),),
          ),
        ],
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                kBox,
                UserInput(
                  controller: carController,
                  hint: 'Enter car number',
                  keyboardType: TextInputType.text,
                  errorText: carNoError,
                ),
                kBox,
                ElevatedButton(
                  onPressed: () async {
                    await fetchCarDetails(
                        carController.text.trim().toUpperCase());
                  },
                  child: const Text('Get Car Details'),
                ),
                kBox,
                if(loading)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 80.0),
                    child: LinearProgressIndicator(
                      color: kPrimaryColor,
                      minHeight: 5.0,
                    ),
                  ),
                kBox,
                if (_visible)
                  carDetails != null
                      ? Column(
                          children: [
                            Text('Owner Name: ${carDetails!['owner_name']}'),
                            Text('Contact: ${carDetails!['contact']}'),
                            Text(
                                'Insurance No.: ${carDetails!['insurance_no']}'),
                            Text(
                                'Insurance Company: ${carDetails!['insurance_company']}'),
                            Text(
                                'Insurance Expiry: ${_formatDate(carDetails!['insurance_expiry'].toDate())}'),
                            kBox,
                            const Text(
                              'Fine History:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: fineHistory.length,
                              itemBuilder: (context, index) {
                                final fine = fineHistory[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 10.0),
                                  child: ListTile(
                                    leading: fine['photo'] != null
                                        ? Image.network(
                                            fine['photo'],
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                          )
                                        : const Icon(
                                            Icons.image_not_supported,
                                            size: 50,
                                          ),
                                    title: Text(
                                      '${fine['date'].toDate().toString()}',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                    subtitle: Text(
                                      'Status: ${fine['status']}',
                                      style: TextStyle(
                                          color: fine['status'] == "Completed"
                                              ? kGreen
                                              : kRed,
                                          fontSize: 18.0),
                                    ),
                                    trailing: Text(
                                      'By: ${fine['by']}',
                                      style: TextStyle(fontSize: 12.0),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        )
                      : const Text('No car details found'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

  // Fetch car details and fine history from Firestore
  Future<void> fetchCarDetails(String carNumber) async {
    setState(() {
      loading = true;
    });
    if (!verifyNumber(carNumber)) {
      return;
    }

    try {
      // Fetch car details
      DocumentSnapshot carDoc =
          await _firestore.collection('cars').doc(carNumber).get();

      if (carDoc.exists) {
        // Fetch fine history for the car
        QuerySnapshot finesSnapshot = await _firestore
            .collection('fines')
            .where('to', isEqualTo: carNumber)
            .get();

        setState(() {
          carDetails = carDoc.data() as Map<String, dynamic>?;
          fineHistory = finesSnapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
          _visible = true;
          loading = false;
        });
      } else {
        setState(() {
          carDetails = null;
          _visible = true;
          loading = false;
        });
      }
    } catch (e) {
      print('Error fetching car details: $e');
      setState(() {
        _visible = false;
        loading = false;
      });
    }
  }

  bool verifyNumber(String number) {
    final regExp = RegExp(r'([A-Z]{2})(\d{1,2})([A-Z]{2})(\d{1,4})');
    final match = regExp.firstMatch(number);

    if (match != null) {
      final stateCode = match.group(1)!;
      final districtCode = match.group(2)!.padLeft(2, '0');
      final letterCode = match.group(3)!;
      final numericCode = match.group(4)!.padLeft(4, '0');
      final formattedPlate = '$stateCode$districtCode$letterCode$numericCode';

      if (regExp.hasMatch(formattedPlate)) {
        setState(() {
          formatedNumberPlate = formattedPlate;
          carNoError = null;
        });
        return true;
      } else {
        setState(() {
          carNoError = "Enter Valid car number";
        });
        return false;
      }
    }
    return false;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
