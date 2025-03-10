import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/Utility/RoundButton.dart';
import 'LicenceSection/FormData.dart';
import '../../Utility/Constants.dart';
import '../../Utility/Appbar.dart';
import 'LicenceSection/FillApplicationForm.dart';
import 'LicenceSection/PaymentScreen.dart';
import 'LicenceSection/ReceiptScreen.dart';
import 'LicenceSection/SelfVerification.dart';
import 'LicenceSection/SlotBooking.dart';
import 'LicenceSection/UploadDocuments.dart';
import 'LicenceSection/UploadPhotoAndSign.dart';

// Step Indicator Widget
class StepIndicator extends StatelessWidget {
  final int currentStep;
  final bool driving; // Total steps in your application

  StepIndicator({
    required this.currentStep,
    this.driving = true,
  });

  @override
  Widget build(BuildContext context) {
    final int totalSteps = driving ? 7 : 5;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(totalSteps, (index) {
        return Row(
          children: [
            Column(
              children: [
                Icon(
                  icons(index) as IconData?,
                  color: index <= currentStep ? kSecondaryColor : Colors.grey,
                ),
                Text(
                  getStepLabel(index), // Function to get step label
                  style: TextStyle(
                    color: index <= currentStep ? kSecondaryColor : Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(width: 15),
          ],
        );
      }),
    );
  }

  IconData icons(int index) {
    if (index == currentStep) {
      return FontAwesomeIcons.circleDot;
    } else if (index < currentStep) {
      return FontAwesomeIcons
          .circleCheck; // Default icon if index is not currentStep
    } else {
      return FontAwesomeIcons.circle;
    }
  }

  String getStepLabel(int index) {
    if (driving) {
      switch (index) {
        case 0:
          return 'Form';
        case 1:
          return ' Photo & Sign';
        case 2:
          return ' Documents';
        case 3:
          return ' Self Verification';
        case 4:
          return ' Payment';
        case 5:
          return ' Slot book';
        case 6:
          return ' Receipt';
        default:
          return '';
      }
    } else {
      switch (index) {
        case 0:
          return 'Form';
        case 1:
          return ' Photo & Sign';
        case 2:
          return ' Documents';
        case 3:
          return ' Payment';
        case 4:
          return ' Receipt';
        default:
          return '';
      }
    }
  }
}

class LicenseApplication extends StatefulWidget {
  static const String id = 'LicenseApplication';

  const LicenseApplication({super.key});

  @override
  State<LicenseApplication> createState() => LicenseApplicationState();
}

class LicenseApplicationState extends State<LicenseApplication> {
  int currentStep = 0;
  final FormData formData = FormData(); // Store form data persistently
  Map<String, dynamic> arguments = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize arguments once

    arguments =
        (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?)!;
    // Debug print to check the arguments

    if (arguments['driving'] == true) {
      getDataForDriving();
    }
    formData.applicantMobileController.text = arguments['mobile'];
  }

  @override
  Widget build(BuildContext context) {
    // Ensure arguments are initialized before accessing them
    int lastIndex = arguments['driving'] ? 6 : 4;

    return Scaffold(
      appBar: Appbar(
        title: arguments['driving']
            ? 'Driving License Application'
            : 'Learning License Application',
        displayUserProfile: true,
        isBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: StepIndicator(
                currentStep: currentStep,
                driving: arguments['driving'],
              ),
            ),
            kBox, // Adds spacing between step indicator and form

            Expanded(
              child: Container(
                width: double.infinity, // Ensures the child takes full width
                child: getCurrentStepContent(),
                // Load content without losing data
              ),
            ),

            // Buttons at the bottom
            Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: Row(
                mainAxisAlignment: currentStep > 0 && currentStep < lastIndex
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.end,
                children: [
                  if (currentStep > 0 && currentStep < lastIndex)
                    RoundButton(
                      onPressed: () {
                        setState(() {
                          currentStep--;
                        });
                      },
                      text: 'Previous',
                    ),
                  RoundButton(
                    onPressed: () async {
                      if (currentStep < lastIndex) {
                        bool isValid = validateForm(currentStep);
                        setState(
                            () {}); // This triggers a UI rebuild so errors appear
                        if (isValid) {
                          if (arguments['driving'] &&
                              currentStep == lastIndex - 1 &&
                              await saveDlForm(formData)) {
                            setState(() {
                              currentStep++;
                            });
                          } else if (currentStep == lastIndex - 1 &&
                              await saveFormData(formData)) {
                            setState(() {
                              currentStep++;
                            });
                          } else if (currentStep == lastIndex) {
                            Navigator.pop(context);
                          } else {
                            
                            setState(() {
                              currentStep++;
                            });
                          }
                          // Proceed to the next step
                        }
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    text: currentStep < lastIndex ? 'Next' : 'Finish',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getCurrentStepContent() {
    if (arguments['driving']) {
      return IndexedStack(
        index: currentStep,
        children: [
          FillApplicationForm(formData: formData),
          UploadPhotoAndSign(formData: formData),
          UploadDocuments(formData: formData),
          SelfVerification(formData: formData),
          PaymentScreen(formData: formData),
          SlotBooking(formData: formData),
          ReceiptScreen(formData: formData),
        ],
      );
    } else {
      return IndexedStack(
        index: currentStep,
        children: [
          FillApplicationForm(formData: formData),
          UploadPhotoAndSign(formData: formData),
          UploadDocuments(formData: formData),
          PaymentScreen(formData: formData),
          ReceiptScreen(formData: formData),
        ],
      );
    }
  }

  Future<void> getDataForDriving() async {
    QuerySnapshot snapshot = await _firestore
        .collection('llapplication')
        .where('applicantMobile', isEqualTo: arguments['mobile'])
        .get();

    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot document = snapshot.docs.first;
      // Set personal and contact details
      formData.selectedState = document['selectedState'];
      formData.selectedDistrict = document['selectedDistrict'];
      formData.pinCodeController.text = document['pinCode'];

      // Set relative details
      formData.fullNameController.text = document['fullName'];
      formData.selectedRelation = document['selectedRelation'];
      formData.relativeFullNameController.text = document['relativeFullName'];

      // Set additional personal details
      formData.selectedGender = document['selectedGender'];
      formData.selectedDateOfBirth =
          DateTime.parse(document['selectedDateOfBirth']);
      formData.placeOfBirthController.text = document['placeOfBirth'];
      formData.selectedCountryOfBirth = document['selectedCountryOfBirth'];
      formData.selectedQualification = document['selectedQualification'];
      formData.selectedBloodGroup = document['selectedBloodGroup'];
      formData.emailController.text = document['email'];
      formData.landlineController.text = document['landline'];
      formData.emergencyMobileController.text = document['emergencyMobile'];
      formData.identityMark1Controller.text = document['identityMark1'];
      formData.identityMark2Controller.text = document['identityMark2'];

      // Set permanent address details
      formData.sameAsPresent = document['sameAsPresent'];
      formData.permanentAddressController.text = document['permanentAddress'];
      formData.permanentDistrict = document['permanentDistrict'];
      formData.permanentLandmarkController.text = document['permanentLandmark'];
      formData.permanentPincodeController.text = document['permanentPincode'];
      formData.permanentState = document['permanentState'];
      formData.permanentTehsilController.text = document['permanentTehsil'];
      formData.permanentVillageController.text = document['permanentVillage'];

      // Set present address details
      formData.presentAddressController.text = document['presentAddress'];
      formData.presentDistrict = document['presentDistrict'];
      formData.presentLandmarkController.text = document['presentLandmark'];
      formData.presentPincodeController.text = document['presentPincode'];
      formData.presentState = document['presentState'];
      formData.presentTehsilController.text = document['presentTehsil'];
      formData.presentVillageController.text = document['presentVillage'];

      // Set vehicle classes (convert to List<String>)
      formData.selectedVehicleClasses =
          List<String>.from(document['selectedVehicleClasses']);

      // Set image and document URLs
      formData.photo = document['photo'];
      formData.signature = document['signature'];
      formData.aadhaarPdf = document['aadhaarPdf'];
      formData.billPdf = document['billPdf'];

      print("Data fetched and set in formData.");
    } else {
      print('No data found for the given mobile number.');
    }
  }

  bool validateForm(int currentStep) {
    formData.clearErrors(); // Clear old errors at start

    if (arguments['driving']) {
      switch (currentStep) {
        case 0:
          return validateFormFields();
        case 1:
          return validatePhotonSign();
        case 2:
          return validateDocument();
        case 3:
          if (formData.selfie == null) {
            formData.fieldErrors['selfie'] = 'PLease upload selfie';
            return false;
          }

          return true;
        case 4:
          if (formData.paymentId == null) {
            formData.fieldErrors['paymentId'] = 'Payment not completed';
            return false;
          }

          return true;
        case 5:
          if (formData.slot_id == null && formData.slot_no == null) {
            formData.fieldErrors['slot'] = 'Select Slot';
            return false;
          }

          return true;

        default:
          return false;
      }
    } else {
      switch (currentStep) {
        case 0:
          return validateFormFields();
        case 1:
          return validatePhotonSign();
        case 2:
          return validateDocument();
        case 3:
          if (formData.paymentId == null) {
            formData.fieldErrors['paymentId'] = 'Payment not completed';
            return false;
          }

          return true;
        default:
          return false;
      }
    }
  }

  bool validateFormFields() {
    bool isValid = true;
    if (formData.selectedState == null) {
      formData.fieldErrors['selectedState'] = 'Please select state';
      isValid = false;
    }
    if (formData.selectedDistrict == null) {
      formData.fieldErrors['selectedDistrict'] = 'Please select district';
      isValid = false;
    }
    // Pincode Validation
    if (formData.pinCodeController.text.isEmpty) {
      formData.fieldErrors['pincode'] = 'Please enter pincode';
      isValid = false;
    } else if (!RegExp(r'^\d{6}$').hasMatch(formData.pinCodeController.text)) {
      formData.fieldErrors['pincode'] = 'Enter valid pincode';
      isValid = false;
    }

    // Personal Details Validation
    if (formData.fullNameController.text.isEmpty) {
      formData.fieldErrors['fullName'] = 'Please enter full name';
      isValid = false;
    }

    if (formData.selectedRelation == null) {
      formData.fieldErrors['relation'] = 'Please select relation';
      isValid = false;
    }

    if (formData.relativeFullNameController.text.isEmpty) {
      formData.fieldErrors['relativeFullName'] =
          'Please enter relative full name';
      isValid = false;
    }

    if (formData.selectedGender == null) {
      formData.fieldErrors['gender'] = 'Please select gender';
      isValid = false;
    }

    if (formData.selectedDateOfBirth == null) {
      formData.fieldErrors['dateOfBirth'] = 'Please select date of birth';
      isValid = false;
    }

    if (formData.placeOfBirthController.text.isEmpty) {
      formData.fieldErrors['placeOfBirth'] = 'Please enter place of birth';
      isValid = false;
    }

    if (formData.selectedCountryOfBirth == null) {
      formData.fieldErrors['countryOfBirth'] = 'Please select country of birth';
      isValid = false;
    }

    if (formData.selectedQualification == null) {
      formData.fieldErrors['qualification'] = 'Please select qualification';
      isValid = false;
    }

    if (formData.selectedBloodGroup == null) {
      formData.fieldErrors['bloodGroup'] = 'Please select blood group';
      isValid = false;
    }

    if (formData.applicantMobileController.text.isEmpty) {
      formData.fieldErrors['applicantMobile'] = 'Please enter mobile number';
      isValid = false;
    } else if (!RegExp(r'^\d{10}$')
        .hasMatch(formData.applicantMobileController.text)) {
      formData.fieldErrors['applicantMobile'] = 'Enter valid phone number';
      isValid = false;
    }

    // Email Validation
    if (formData.emailController.text.isEmpty) {
      formData.fieldErrors['email'] = 'Please enter email address';
      isValid = false;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$')
        .hasMatch(formData.emailController.text)) {
      formData.fieldErrors['email'] = 'Please enter a valid email address';
      isValid = false;
    }

    // Present Address Validation
    if (formData.presentState == null) {
      formData.fieldErrors['presentState'] = 'Please select present state';
      isValid = false;
    }

    if (formData.presentDistrict == null) {
      formData.fieldErrors['presentDistrict'] =
          'Please select present district';
      isValid = false;
    }

    if (formData.presentTehsilController.text.isEmpty) {
      formData.fieldErrors['presentTehsil'] = 'Please enter present tehsil';
      isValid = false;
    }

    if (formData.presentVillageController.text.isEmpty) {
      formData.fieldErrors['presentVillage'] = 'Please enter present village';
      isValid = false;
    }

    if (formData.presentAddressController.text.isEmpty) {
      formData.fieldErrors['presentAddress'] = 'Please enter present address';
      isValid = false;
    }

    if (formData.presentPincodeController.text.isEmpty) {
      formData.fieldErrors['presentPincode'] = 'Please enter present pincode';
      isValid = false;
    } else if (!RegExp(r'^\d{6}$')
        .hasMatch(formData.presentPincodeController.text)) {
      formData.fieldErrors['presentPincode'] = 'Enter valid pincode';
      isValid = false;
    }

    // Permanent Address (if not same as present)
    if (!formData.sameAsPresent) {
      if (formData.permanentState == null) {
        formData.fieldErrors['permanentState'] =
            'Please select permanent state';
        isValid = false;
      }

      if (formData.permanentDistrict == null) {
        formData.fieldErrors['permanentDistrict'] =
            'Please select permanent district';
        isValid = false;
      }

      if (formData.permanentTehsilController.text.isEmpty) {
        formData.fieldErrors['permanentTehsil'] =
            'Please enter permanent tehsil';
        isValid = false;
      }

      if (formData.permanentVillageController.text.isEmpty) {
        formData.fieldErrors['permanentVillage'] =
            'Please enter permanent village';
        isValid = false;
      }

      if (formData.permanentAddressController.text.isEmpty) {
        formData.fieldErrors['permanentAddress'] =
            'Please enter permanent address';
        isValid = false;
      }

      if (formData.permanentPincodeController.text.isEmpty) {
        formData.fieldErrors['permanentPincode'] =
            'Please enter permanent pincode';
        isValid = false;
      } else if (!RegExp(r'^\d{6}$')
          .hasMatch(formData.permanentPincodeController.text)) {
        formData.fieldErrors['permanentPincode'] = 'Enter valid pincode';
        isValid = false;
      }
    }

    // Declaration
    if (!formData.declarationChecked) {
      formData.fieldErrors['declarationChecked'] =
          'Please accept the declaration';
      isValid = false;
    }

    // Vehicle Class
    if (formData.selectedVehicleClasses.isEmpty) {
      formData.fieldErrors['vehicleClasses'] =
          'Please select at least one vehicle class';
      isValid = false;
    }

    // Declaration Questions
    if (formData.declarationAnswer1 == null) {
      formData.fieldErrors['declarationAnswer1'] = 'Please select your answer';
      isValid = false;
    }
    if (formData.declarationAnswer2 == null) {
      formData.fieldErrors['declarationAnswer2'] = 'Please select your answer';
      isValid = false;
    }
    if (formData.declarationAnswer3 == null) {
      formData.fieldErrors['declarationAnswer3'] = 'Please select your answer';
      isValid = false;
    }
    if (formData.declarationAnswer4 == null) {
      formData.fieldErrors['declarationAnswer4'] = 'Please select your answer';
      isValid = false;
    }
    if (formData.declarationAnswer5 == null) {
      formData.fieldErrors['declarationAnswer5'] = 'Please select your answer';
      isValid = false;
    }
    if (formData.declarationAnswer6 == null) {
      formData.fieldErrors['declarationAnswer6'] = 'Please select your answer';
      isValid = false;
    }

    // Organ Donation and Acknowledgement
    if (formData.donateOrgan == null) {
      formData.fieldErrors['donateOrgan'] =
          'Please select organ donation preference';
      isValid = false;
    }

    if (!formData.acknowledgement) {
      formData.fieldErrors['acknowledgement'] = 'Please check the checkbox';
      isValid = false;
    }

    return isValid;
  }

  bool validatePhotonSign() {
    bool isValid = true;
    if (formData.photo == null) {
      formData.fieldErrors['photo'] = 'Please upload a photo';
      isValid = false;
    }

    if (formData.signature == null) {
      formData.fieldErrors['signature'] = 'Please upload signature';
      isValid = false;
    }

    return isValid;
  }

  bool validateDocument() {
    bool isValid = true;
    if (formData.aadhaarPdf == null) {
      formData.fieldErrors['aadhaarPdf'] = 'Please upload Aadhaar PDF';
      isValid = false;
    }

    if (formData.billPdf == null) {
      formData.fieldErrors['billPdf'] = 'Please upload bill PDF';
      isValid = false;
    }

    return isValid;
  }

  Future<bool> saveFormData(FormData formData) async {
    final String id = DateTime.now().millisecondsSinceEpoch.toString();
    formData.receiptId = id;
    await _firestore
        .collection('llapplication')
        .doc(id)
        .set(formData.toMap())
        .then((_) {
      print("Form saved successfully!");
      return true;
    }).catchError((error) {
      print("Failed to save form: $error");
      return false;
    });
    return false;
  }

  Future<bool> saveDlForm(FormData formData) async {
    final String id = DateTime.now().millisecondsSinceEpoch.toString();
    formData.receiptId = id; // Set receiptId before saving to Firestore

    try {
      await _firestore
          .collection('dlapplication')
          .doc(id)
          .set(formData.toMapDl());

      print("Form saved successfully!");
      await bookSlot(
          formData); // Ensure formData.receiptId is set before calling bookSlot

      return true;
    } catch (error) {
      print("Failed to save form: $error");
      return false;
    }
  }

  Future<void> bookSlot(FormData formData) async {
    try {
      String slot = formData.slot_no ?? 'slot1';
      await _firestore.collection('slots').doc(formData.slot_id).update({
        '$slot.applicationsId': FieldValue.arrayUnion([formData.receiptId]),
        '$slot.remaining': FieldValue.increment(-1),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Slot booked successfully!')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error booking slot: $error')),
      );
    }
  }
}
