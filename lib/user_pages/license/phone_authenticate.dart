import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter/material.dart';
import '../../utility/appbar.dart';
import '../../utility/constants.dart';
import '../../utility/otp_field.dart';
import '../../utility/round_button.dart';
import '../../utility/user_input.dart';
import 'license_application.dart';

class PhoneAuthenticate extends StatefulWidget {
  static const String id = 'user/license/phontauthenticate';
  const PhoneAuthenticate({super.key});

  @override
  _PhoneAuthenticateState createState() => _PhoneAuthenticateState();
}

class _PhoneAuthenticateState extends State<PhoneAuthenticate> {
  String? llapplicationId, mobileError, buttonText = 'Generate OTP';
  String verificationId = '';
  bool otpEnable = false, loading = false;
  final TextEditingController licenseIdController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  late PhoneAuthCredential credential;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> fetchApplicationData() async {
    QuerySnapshot snapshot = await _fireStore
        .collection('llapplication')
        .where('licenseNumber',
            isEqualTo: 'LL-${licenseIdController.text.trim()}')
        .get();

    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot document = snapshot.docs.first;
      DateTime applicationDate = DateTime.parse(document['payementDate']);
      DateTime currentDate = DateTime.now();

      if (currentDate.difference(applicationDate).inDays > 15) {
        setState(() {
          llapplicationId = 'LL-${licenseIdController.text.trim()}';
          _phoneController.text = document['applicantMobile'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please wait for the 15 days period to complete before appling for DL.'),
            backgroundColor: kRed,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No data found for the License number.'),
          backgroundColor: kRed,
        ),
      );
    }
  }
  

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: Appbar(
        title: arguments['driving'] == true
            ? 'Authenticate '
            : 'Authenticate Phone Number',
        isBackButton: true,
        displayUserProfile: true,
      ),
      body: arguments['driving'] == true
          ? ModalProgressHUD(
              progressIndicator: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    kSecondaryColor), // Set custom color
              ),
              inAsyncCall: loading,
              child: llapplicationId == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'If LL number is LL - 11111111\nthen enter 1111111 in the box',
                          style: TextStyle(color: kGrey, fontSize: 16),
                        ),
                        kBox,
                        Align(
                          alignment: Alignment.center,
                          child: UserInput(
                            controller: licenseIdController,
                            hint: 'Enter Learning License Number',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        kBox,
                        RoundButton(
                          onPressed: fetchApplicationData,
                          text: 'Submit',
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Found details verify to continue',
                          style: TextStyle(color: kGreen, fontSize: 16),
                        ),
                        kBox,
                        Align(
                          alignment: Alignment.center,
                          child: UserInput(
                            controller: _phoneController,
                            hint: 'Enter Mobile No.',
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                            errorText: mobileError,
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        if (otpEnable)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 80.0),
                            child: OTPField(
                              controller: _otpController,
                            ),
                          ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        RoundButton(
                          onPressed: () {
                            if (_validateMobile(_phoneController.text)) {
                              FocusScope.of(context).unfocus();
                              otpEnable ? _verifyOTP() : _sendOTP();
                            }
                          },
                          text: buttonText,
                        ),
                      ],
                    ),
            )
          : ModalProgressHUD(
              progressIndicator: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    kSecondaryColor), // Set custom color
              ),
              inAsyncCall: loading,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: UserInput(
                      controller: _phoneController,
                      hint: 'Enter Mobile No.',
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      errorText: mobileError,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  if (otpEnable)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 80.0),
                      child: OTPField(
                        controller: _otpController,
                      ),
                    ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  RoundButton(
                    onPressed: () {
                      if (_validateMobile(_phoneController.text)) {
                        FocusScope.of(context).unfocus();
                        otpEnable ? _verifyOTP() : _sendOTP();
                      }
                    },
                    text: buttonText,
                  ),
                ],
              ),
            ),
    );
  }

  bool _validateMobile(String number) {
    if (!number.isEmpty && number.length >= 10) {
      setState(() {
        mobileError = null;
      });
      return true;
    } else {
      setState(() {
        mobileError = "Enter valid Mobile number";
      });
    }
    return false;
  }

  void _sendOTP() async {
    setState(() {
      loading = true;
      otpEnable = true;
      buttonText = 'Verify OTP';
    });
    await _auth.verifyPhoneNumber(
      phoneNumber: '+91${_phoneController.text}',
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {
        setState(() => loading = false);
        if (e.code == 'too-many-requests') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Too many attempts. Try again later.'), backgroundColor: kRed,),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? 'OTP verification failed.'), backgroundColor: kRed,),
          );
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          this.verificationId = verificationId;
          loading = false;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() => verificationId = verificationId);
      },
    );
  }

  void _verifyOTP() async {
    setState(() {
      loading = true;
    });

    String smsCode = _otpController.text.trim();

    if (verificationId.isNotEmpty) {
      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: smsCode,
        );

        // Create a secondary Firebase App instance
        FirebaseApp tempApp = await Firebase.initializeApp(
          name: 'TemporaryApp',
          options: Firebase.app().options,
        );

        FirebaseAuth tempAuth = FirebaseAuth.instanceFor(app: tempApp);

        // Sign in with OTP in temp instance (won't affect main app)
        UserCredential userCredential =
            await tempAuth.signInWithCredential(credential);

        if (userCredential.user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Phone number verified successfully'), backgroundColor: kGreen,),
          );

          setState(() {
            loading = false;
            otpEnable = false;
          });

          // Close the temporary Firebase app (to free resources)
          await tempApp.delete();

          // Navigate to the next screen
          Navigator.pushReplacementNamed(
            context,
            LicenseApplication.id,
            arguments: {
              'mobile': _phoneController.text.trim(),
              'driving': llapplicationId != null,
            },
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to verify OTP. Try again later'),
              backgroundColor: kRed,),
        );
        setState(() {
          loading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verification ID is null or empty.'), backgroundColor: kRed,),
      );
      setState(() {
        loading = false;
      });
    }
  }
}
