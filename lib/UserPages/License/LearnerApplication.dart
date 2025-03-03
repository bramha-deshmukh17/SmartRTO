import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/Utility/RoundButton.dart';
import './LernerLicenceSection/FormData.dart';
import '../../Utility/Constants.dart';
import '../../Utility/Appbar.dart';
import './LernerLicenceSection/FillApplicationForm.dart';
import 'LernerLicenceSection/PaymentScreen.dart';
import 'LernerLicenceSection/ReceiptScreen.dart';
import 'LernerLicenceSection/UploadDocuments.dart';
import 'LernerLicenceSection/UploadPhotoAndSign.dart';

// Step Indicator Widget
class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps = 5; // Total steps in your application

  StepIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
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

class LearnerLicenseApplication extends StatefulWidget {
  static const String id = 'LearnerLicenseApplication';

  const LearnerLicenseApplication({super.key});

  @override
  State<LearnerLicenseApplication> createState() =>
      _LearnerLicenseApplicationState();
}

class _LearnerLicenseApplicationState extends State<LearnerLicenseApplication> {
  int currentStep = 0;
  final FormData formData = FormData(); // Store form data persistently

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        title: 'Learner License Application',
        displayUserProfile: true,
        isBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        child: Column(
          children: [
            StepIndicator(currentStep: currentStep),
            SizedBox(
                height: 20), // Adds spacing between step indicator and form

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
                mainAxisAlignment: currentStep > 0 && currentStep < 4
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.end,
                children: [
                  if (currentStep > 0 && currentStep < 4)
                    RoundButton(
                      onPressed: () {
                        setState(() {
                          currentStep--;
                        });
                      },
                      text: 'Previous',
                    ),
                  RoundButton(
                    onPressed: ()async {
                      if (currentStep < 4) {
                        bool isValid = validateForm(currentStep);
                        setState(
                            () {}); // This triggers a UI rebuild so errors appear
                        if (isValid) {
                          if (currentStep == 3 && await saveFormData(formData)) {
                            setState(() {
                              currentStep++;
                            });
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
                    text: currentStep < 4 ? 'Next' : 'Finish',
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

  bool validateForm(int currentStep) {
    formData.clearErrors(); // Clear old errors at start

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
      formData.fieldErrors['applicantMobile'] = 'Enter valida phone number';
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
    await FirebaseFirestore.instance
        .collection('llapplication')
        .doc(id)
        .set(formData.toMap())
        .then((_) {
      print("Form saved successfully!");
      setState(() {
        formData.receiptId = id;
      });
      return true;
    }).catchError((error) {
      print("Failed to save form: $error");
      return false;
    });
    return false;
  }
}
