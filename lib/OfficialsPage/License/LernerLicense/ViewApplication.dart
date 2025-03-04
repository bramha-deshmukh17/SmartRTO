import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../Utility/Appbar.dart';
import '../../../Utility/Constants.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

import '../../../Utility/RoundButton.dart';

class ViewApplication extends StatefulWidget {
  final String applicationId;

  const ViewApplication({Key? key, required this.applicationId})
      : super(key: key);

  @override
  _ViewApplicationState createState() => _ViewApplicationState();
}

class _ViewApplicationState extends State<ViewApplication> {
  Map<String, dynamic>? applicationData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchApplicationData();
  }

  Future<void> fetchApplicationData() async {
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
        .collection('llapplication')
        .doc(widget.applicationId)
        .get();

    if (docSnapshot.exists) {
      setState(() {
        applicationData = docSnapshot.data() as Map<String, dynamic>?;
        isLoading = false;
      });
    }
  }

  Future<void> approveApplication() async {
    String licenseNumber = 'LL-${DateTime.now().millisecondsSinceEpoch}';
    await FirebaseFirestore.instance
        .collection('llapplication')
        .doc(widget.applicationId)
        .update({
      'approved': true,
      'licenseNumber': licenseNumber,
    });

    setState(() {
      applicationData?['approved'] = true;
      applicationData?['licenseNumber'] = licenseNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        title: 'Application Details',
        isBackButton: true,
        displayOfficerProfile: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Application ID: ${widget.applicationId}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  kBox,
                  Text(
                    'Full Name: ${applicationData?['fullName'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Email: ${applicationData?['email'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Mobile: ${applicationData?['applicantMobile'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Address: ${applicationData?['presentAddress'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Exam Result: ${applicationData?['examResult'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Marks: ${applicationData?['marks'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Selected State: ${applicationData?['selectedState'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Selected District: ${applicationData?['selectedDistrict'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Pincode: ${applicationData?['pinCode'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Relation: ${applicationData?['selectedRelation'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Relative Full Name: ${applicationData?['relativeFullName'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Gender: ${applicationData?['selectedGender'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Date of Birth: ${applicationData?['selectedDateOfBirth'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Place of Birth: ${applicationData?['placeOfBirth'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Country of Birth: ${applicationData?['selectedCountryOfBirth'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Qualification: ${applicationData?['selectedQualification'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Blood Group: ${applicationData?['selectedBloodGroup'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Landline: ${applicationData?['landline'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Emergency Mobile: ${applicationData?['emergencyMobile'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Identity Mark 1: ${applicationData?['identityMark1'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Identity Mark 2: ${applicationData?['identityMark2'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Present State: ${applicationData?['presentState'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Present District: ${applicationData?['presentDistrict'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Present Tehsil: ${applicationData?['presentTehsil'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Present Village: ${applicationData?['presentVillage'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Present Landmark: ${applicationData?['presentLandmark'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Permanent State: ${applicationData?['permanentState'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Permanent District: ${applicationData?['permanentDistrict'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Permanent Tehsil: ${applicationData?['permanentTehsil'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Permanent Village: ${applicationData?['permanentVillage'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Permanent Address: ${applicationData?['permanentAddress'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Permanent Landmark: ${applicationData?['permanentLandmark'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Permanent Pincode: ${applicationData?['permanentPincode'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Declaration Answer 1: ${applicationData?['declarationAnswer1'] ? 'YES' : 'NO'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Declaration Answer 2: ${applicationData?['declarationAnswer2'] ? 'YES' : 'NO'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Declaration Answer 3: ${applicationData?['declarationAnswer3'] ? 'YES' : 'NO'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Declaration Answer 4: ${applicationData?['declarationAnswer4'] ? 'YES' : 'NO'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Declaration Answer 5: ${applicationData?['declarationAnswer5'] ? 'YES' : 'NO'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Declaration Answer 6: ${applicationData?['declarationAnswer6'] ? 'YES' : 'NO'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Declaration Checked: ${applicationData?['declarationChecked'] ? 'YES' : 'NO'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Selected Vehicle Classes: ${applicationData?['selectedVehicleClasses']?.join(', ') ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Donate Organ: ${applicationData?['donateOrgan'] ? 'YES' : 'NO'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Acknowledgement: ${applicationData?['acknowledgement'] ? 'YES' : 'NO'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  // Photo (JPG)
                  kBox,
                   Text(
                    'Payment ID: ${applicationData?['paymentId'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  Text(
                    'Payment Date: ${applicationData?['payementDate'] ?? 'N/A'}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  kBox,
                  if (applicationData?['approved'] == true)
                    Text(
                      'License Number: ${applicationData?['licenseNumber'] ?? 'N/A'}',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  kBox,
                  Text(
                    'Photo:',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  kBox,
                  applicationData?['photo'] != null &&
                          applicationData!['photo'].toString().isNotEmpty
                      ? Image.network(
                          applicationData!['photo'],
                          height: 200,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
                              const Text('Image not available'),
                        )
                      : const Text(
                          'N/A',
                          style: TextStyle(fontSize: 16),
                        ),
                  // Signature (JPG)
                  kBox,
                  Text(
                    'Signature:',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  kBox,
                  applicationData?['signature'] != null &&
                          applicationData!['signature'].toString().isNotEmpty
                      ? Image.network(
                          applicationData!['signature'],
                          height: 200,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
                              const Text('Image not available'),
                        )
                      : const Text(
                          'N/A',
                          style: TextStyle(fontSize: 16),
                        ),
                  // Aadhaar PDF Preview (PDF)
                  kBox,
                  Text(
                    'Aadhaar PDF Preview:',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  kBox,
                  applicationData?['aadhaarPdf'] != null &&
                          applicationData!['aadhaarPdf'].toString().isNotEmpty
                      ? Container(
                          height: 300,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: PDF(
                                  swipeHorizontal: true,
                                  enableSwipe: true,
                                  fitPolicy: FitPolicy.BOTH)
                              .cachedFromUrl(
                            applicationData!['aadhaarPdf'],
                          ),
                        )
                      : const Text(
                          'N/A',
                          style: TextStyle(fontSize: 16),
                        ),
                  // Bill PDF Preview (PDF)
                  kBox,
                  Text(
                    'Address proof PDF Preview:',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  kBox,
                  applicationData?['billPdf'] != null &&
                          applicationData!['billPdf'].toString().isNotEmpty
                      ? Container(
                          height: 300,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: PDF(
                                  swipeHorizontal: true,
                                  enableSwipe: true,
                                  fitPolicy: FitPolicy.BOTH)
                              .cachedFromUrl(
                            applicationData!['billPdf'],
                          ),
                        )
                      : const Text(
                          'N/A',
                          style: TextStyle(fontSize: 16),
                        ),
                  kBox,
                 
                  if (applicationData?['approved'] != true)
                    RoundButton(onPressed: approveApplication, text: 'Approve and Generate License Number',),
                  kBox,
                ],
              ),
            ),
    );
  }
}
