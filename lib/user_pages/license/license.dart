import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utility/appbar.dart';
import '../../utility/constants.dart';

class LicenseInfoPage extends StatefulWidget {
  static const String id = 'user/license';

  const LicenseInfoPage({Key? key}) : super(key: key);

  @override
  _LicenseInfoPageState createState() => _LicenseInfoPageState();
}

class _LicenseInfoPageState extends State<LicenseInfoPage> {
  Map<String, dynamic>? licenseData;
  String? mobileNumber;
  bool loading = true, driving = true;

  Future<void> _fetchMobileNumber() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        mobileNumber = user.phoneNumber;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMobileNumber().then((_) {
      if (mobileNumber != null) {
        fetchLicenseData();
      }
    });
  }

  Future<void> fetchLicenseData() async {
    //fetch user license first check for dl if not found then go for ll
    try {
      setState(() {
        loading = true;
      });

      // Query Firestore for driving license (DL) data
      final QuerySnapshot dlSnapshot = await FirebaseFirestore.instance
          .collection('dlapplication')
          .where('applicantMobile', isEqualTo: mobileNumber)
          .get();

      if (dlSnapshot.docs.isNotEmpty) {
        Map<String, dynamic> dlData =
            dlSnapshot.docs.first.data() as Map<String, dynamic>;

        if (dlData.containsKey('licenseNumber') &&
            dlData['licenseNumber'].toString().isNotEmpty) {
          setState(() {
            licenseData = dlData;
            loading = false;
          });
          return; // Exit if DL is found
        }
      }

      // If no valid DL found, check learner's license (LL) data
      final QuerySnapshot llSnapshot = await FirebaseFirestore.instance
          .collection('llapplication')
          .where('applicantMobile', isEqualTo: mobileNumber)
          .get();

      if (llSnapshot.docs.isNotEmpty) {
        Map<String, dynamic> llData =
            llSnapshot.docs.first.data() as Map<String, dynamic>;

        if (llData.containsKey('licenseNumber') &&
            llData['licenseNumber'].toString().isNotEmpty) {
          setState(() {
            licenseData = llData;
            loading = false;
            driving = false;
          });
          return; // Exit if LL is found
        }
      }

      // If neither DL nor LL is found, show error
      setState(() {
        licenseData = null; // Reset data
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No license data found for this mobile number.')),
      );
    } catch (e) {
      print("Error fetching license data: $e");
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    //display license data
    return Scaffold(
      appBar: Appbar(
        title: 'License Details',
        isBackButton: true,
        displayUserProfile: true,
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(
              color: kSecondaryColor,
            ))
          : licenseData == null
              ? Center(
                  child: Text("No License data availble for this mobile number."),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "License Holder Name: ${licenseData!['fullName']}",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "DL Number: ${licenseData!['licenseNumber']}",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Photo:",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Image.network(
                              licenseData!['photo'],
                              height: 150,
                              width: 150,
                              errorBuilder: (context, error, stackTrace) {
                                return const Text("Failed to load photo.");
                              },
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Signature:",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Image.network(
                              licenseData!['signature'],
                              height: 50,
                              width: 150,
                              errorBuilder: (context, error, stackTrace) {
                                return const Text("Failed to load signature.");
                              },
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Date of Birth: ${_formatDate(DateTime.parse(licenseData!['selectedDateOfBirth']))}",
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Gender: ${licenseData!['selectedGender']}",
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Issue Date: ${_formatDate(DateTime.parse(licenseData!['payementDate']))}",
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 8),
                            const SizedBox(height: 8),
                            Text(
                              "Address: ${licenseData!['permanentAddress']}",
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Mobile: ${licenseData!['applicantMobile']}",
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Expiry on: ${_calculateExpiryDate(licenseData!['payementDate'], driving)}",
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
    );
  }

// Function to calculate the expiry date based on license type
  String _calculateExpiryDate(String paymentDate, bool licenseType) {
    DateTime paymentDateTime = DateTime.parse(paymentDate);
    DateTime expiryDate;

    if (licenseType) {
      // Add 6 months for learning license
      expiryDate = paymentDateTime.add(Duration(days: 6 * 30));
    } else {
      // Add 20 years for driving license
      expiryDate = paymentDateTime.add(Duration(days: 20 * 365));
    }

    return _formatDate(expiryDate);
  }
}
