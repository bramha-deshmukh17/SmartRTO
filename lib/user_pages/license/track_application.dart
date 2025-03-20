import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utility/appbar.dart';
import '../../utility/constants.dart';
import '../../utility/round_button.dart';
import '../../utility/user_input.dart';

class TrackApplication extends StatefulWidget {
  static const String id = 'user/application/track';

  const TrackApplication({super.key});

  @override
  _TrackApplicationState createState() => _TrackApplicationState();
}

class _TrackApplicationState extends State<TrackApplication> {
  final TextEditingController _applicationNumberController =
      TextEditingController();
  String? applicationType, applicationTypeError, applicationInput;
  List<String> applicationTypeList = [
    'Select application type',
    'Learning License',
    'Driving License',
  ];

  Map<String, dynamic>? applicationData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        title: 'Track Application',
        displayUserProfile: true,
        isBackButton: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: kDropdown(
                "District",
                errorText: applicationTypeError,
              ),
              value: applicationTypeList[0],
              items: applicationTypeList.map((district) {
                return DropdownMenuItem<String>(
                  value: district,
                  child: Text(district),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  if (newValue != applicationTypeList[0]) {
                    applicationType = newValue;
                    print('type: $applicationType');
                  } else {
                    applicationType = null;
                  }
                });
              },
            ),
            kBox,
            UserInput(
              controller: _applicationNumberController,
              hint: 'Enter application Number',
              keyboardType: TextInputType.number,
              errorText: applicationInput,
              width: double.infinity,
            ),
            kBox,
            RoundButton(
              onPressed: fetchStatus,
              text: 'Track',
            ),
            if (applicationData != null) ...[
              const SizedBox(height: 20),
              const Text(
                "Application Details:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
                Text(
                'Application Number: ${_applicationNumberController.text}',
                style: TextStyle(fontSize: 16),
                ),
                Text(
                'Applicant Name: ${applicationData?['fullName'] ?? 'N/A'}',
                style: TextStyle(fontSize: 16),
                ),
                Text(
                'Applicant Mobile: ${applicationData?['applicantMobile'] ?? 'N/A'}',
                style: TextStyle(fontSize: 16),
                ),

              kBox,
              // Step Indicator Row
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Applied Step (always complete)
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                    Expanded(
                      child: Container(
                        height: 2,
                        color: Colors.grey,
                      ),
                    ),
                    // Exam Cleared Step
                    Icon(
                      (applicationData?['examResult'] == true)
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: (applicationData?['examResult'] == true)
                          ? Colors.green
                          : Colors.grey,
                    ),
                    Expanded(
                      child: Container(
                        height: 2,
                        color: Colors.grey,
                      ),
                    ),
                    // Approved Step
                    Icon(
                      (applicationData?['approved'] == true)
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: (applicationData?['approved'] == true)
                          ? Colors.green
                          : Colors.grey,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Applied Step (always complete)
                    Text('Applied'),
                    
                    // Exam Cleared Step
                    Text('Exam Cleared'),
                    
                    // Approved Step
                    Text('Approved'),
                  ],
                ),
              ),
              kBox,
              // Show license number if approved
              if (applicationData?['approved'] == true &&
                  applicationData?['licenseNumber'] != null)
                Text(
                  "License Number: ${applicationData!['licenseNumber']}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> fetchStatus() async {
    if (applicationType == null) {
      setState(() {
        applicationTypeError = 'Please select application type';
      });
    }
    if (_applicationNumberController.text.isEmpty) {
      setState(() {
        applicationInput = 'Please enter application number';
      });
    }
    if (applicationType == null || _applicationNumberController.text.isEmpty) {
      return;
    }

    String collectionPath = applicationType == 'Learning License'
        ? 'llapplication'
        : 'dlapplication';

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection(collectionPath)
          .doc(_applicationNumberController.text)
          .get();

      setState(() {
        if (!snapshot.exists) {
          applicationData = null;
        } else {
          applicationData = snapshot.data() as Map<String, dynamic>?;
        }
      });
    } catch (e) {
      setState(() {
        applicationData = null;
      });
    }
  }
}
