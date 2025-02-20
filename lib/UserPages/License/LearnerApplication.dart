import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
            SizedBox(height: 20), // Adds spacing between step indicator and form

            Expanded(
              child: Container(
                width: double.infinity, // Ensures the child takes full width
                child: getCurrentStepContent(),
              ),
            ),
            // Buttons at the bottom
            Row(
              mainAxisAlignment: currentStep == 0
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.spaceBetween,
              
              children: [
                if (currentStep > 0)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentStep--;
                      });
                    },
                    child: Text('Previous'),
                  ),
                ElevatedButton(
                  onPressed: () {
                    saveFormData();
                    if (currentStep < 4) {
                      setState(() {
                        currentStep++;
                      });
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Text(currentStep < 4 ? 'Next' : 'Finish'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getCurrentStepContent() {
    final FormData formData = FormData();

    switch (currentStep) {
      case 0:
        return FillApplicationForm(formData: formData);
      case 1:
        return UploadPhotoAndSign(formData: formData);
      case 2:
        return UploadDocuments(formData: formData);
      case 3:
        return PaymentScreen(formData: formData);
      case 4:
        return ReceiptScreen(formData: formData);
      default:
        return Container();
    }
  }

  void saveFormData() {
    // Save form data at each step if needed
  }
}
