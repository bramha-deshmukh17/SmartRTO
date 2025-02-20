import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Utility/Appbar.dart';
import '../../Utility/Constants.dart';

class LicenseInfoPage extends StatefulWidget {
  static const String id = 'LicensePage';

  const LicenseInfoPage({Key? key}) : super(key: key);

  @override
  _LicenseInfoPageState createState() => _LicenseInfoPageState();
}

class _LicenseInfoPageState extends State<LicenseInfoPage> {
  Map<String, dynamic>? licenseData;
  String? mobileNumber;

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
    try {
      // Query Firestore for license data using the mobile number
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('license')
          .where('mobile', isEqualTo: mobileNumber)
          .get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          licenseData = snapshot.docs.first.data() as Map<String, dynamic>;
        });
      } else {
        print("No license data found for this mobile number.");
      }
    } catch (e) {
      print("Error fetching license data: $e");
    }
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        title: 'License Details',
        isBackButton: true,
        displayUserProfile: true,
      ),
      body: licenseData == null
          ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(kSecondaryColor),))
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
                    "License Holder Name: ${licenseData!['license_holder_name']}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "DL Number: ${licenseData!['license_number']}",
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
                    licenseData!['photo_url'],
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
                    licenseData!['signature_url'],
                    height: 50,
                    width: 150,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text("Failed to load signature.");
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Date of Birth: ${_formatDate(licenseData!['date_of_birth'].toDate())}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Gender: ${licenseData!['gender']}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Issue Date: ${_formatDate(licenseData!['issue_date'].toDate())}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Expiration Date: ${_formatDate(licenseData!['expiration_date'].toDate())}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Address: ${licenseData!['address']}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Mobile: ${licenseData!['mobile']}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Restrictions: ${licenseData!['restrictions']?.join(', ') ?? 'None'}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Endorsements: ${licenseData!['endorsements']?.join(', ') ?? 'None'}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
