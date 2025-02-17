import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Utility/Appbar.dart';
import '/Utility/RoundButton.dart';

import '../../Utility/Constants.dart';
import '../../Utility/UserInput.dart';

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

  final TextEditingController carController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        title: 'View Details',
        isBackButton: true,
        displayOfficerProfile: true,
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
                RoundButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      await fetchCarDetails(
                          carController.text.trim().toUpperCase());
                      setState(() {
                        loading = false;
                      });
                    },
                    text: 'Get Car Details'),
                kBox,
                if (loading)
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
                                          color: fine['status'] == "Paid"
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
    // Correct regex for Indian number plates
    final regExp = RegExp(r'^[A-Z]{2}\d{1,2}[A-Z]{1,2}\d{4}$');

    if (regExp.hasMatch(number)) {
      // Extract components of the number plate and format it
      final stateCode = number.substring(0, 2);
      final districtCode = number.substring(2, 4).padLeft(2, '0');
      final letterCode =
          number.length > 8 ? number.substring(4, 6) : number.substring(4, 5);
      final numericCode = number.substring(number.length - 4).padLeft(4, '0');

      final formattedPlate = '$stateCode$districtCode$letterCode$numericCode';

      // Update formatted number and reset the error
      setState(() {
        formatedNumberPlate = formattedPlate;
        carNoError = null;
      });
      return true;
    } else {
      // If regex doesn't match, show error
      setState(() {
        carNoError = "Enter a valid car number";
      });
      return false;
    }
  }
}
