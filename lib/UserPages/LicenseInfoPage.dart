import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Utility/Constants.dart';

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
    User? user = FirebaseAuth.instance.currentUser; // Get the current user
    if (user != null) {
      setState(() {
        mobileNumber = user.phoneNumber; // Fetch the phone number
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchMobileNumber();
    fetchLicenseData();
  }

  Future<void> fetchLicenseData() async {
    // Dummy data for demonstration
    licenseData = {
      "license_holder_name": "Rahul Sharma",
      "license_number": "DL1234567890123",
      "date_of_birth": DateTime.parse("1990-05-15"),
      "gender": "Male",
      "issue_date": DateTime.parse("2020-06-01"),
      "expiration_date": DateTime.parse("2030-05-31"),
      "address": "456, Green Street, New Delhi, Delhi, 110001",
      "mobile": "+919876543210",
      "class": "Class B",
      "photo_url": "http://example.com/photo.jpg",
      "signature_url": "http://example.com/signature.jpg",
      "restrictions": ["None"],
      "endorsements": ["None"]
    };
    setState(() {}); // Update the state to reflect the fetched data
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: kBackArrow,
        ),
        title: kAppBarTitle,
      ),
      body: licenseData == null
          ? const Center(child: CircularProgressIndicator())
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
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Date of Birth: ${_formatDate(licenseData!['date_of_birth'])}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Gender: ${licenseData!['gender']}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Issue Date: ${_formatDate(licenseData!['issue_date'])}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Expiration Date: ${_formatDate(licenseData!['expiration_date'])}",
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
