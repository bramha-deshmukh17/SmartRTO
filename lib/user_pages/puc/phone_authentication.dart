import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../Utility/Constants.dart';
import '../../utility/appbar.dart';
import '../../utility/otp_field.dart';
import '../../utility/round_button.dart';
import '../../utility/user_input.dart';
import 'puc_application.dart';

class PhoneAuthentication extends StatefulWidget {
  static const String id = 'user/phontauthenticate/puc';
  @override
  _PhoneAuthenticationState createState() => _PhoneAuthenticationState();
}

class _PhoneAuthenticationState extends State<PhoneAuthentication> {
  String? mobileError, buttonText = 'Generate OTP';
  String verificationId = '';
  bool otpEnable = false, loading = false;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  late PhoneAuthCredential credential;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: Appbar(
        title: 'Authenticate Phone Number',
        isBackButton: true,
        displayUserProfile: true,
      ),
      body: ModalProgressHUD(
              progressIndicator: const CircularProgressIndicator(
                color: kSecondaryColor, // Set custom color
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
              content: Text('Too many attempts. Try again later.'),
              backgroundColor: kRed,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message ?? 'OTP verification failed.'),
              backgroundColor: kRed,
            ),
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
            const SnackBar(
              content: Text('Phone number verified successfully'),
              backgroundColor: kGreen,
            ),
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
            PucApplication.id,
            arguments: {
              'mobile': _phoneController.text.trim(),
            },
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to verify OTP. Try again later'),
            backgroundColor: kRed,
          ),
        );
        setState(() {
          loading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification ID is null or empty.'),
          backgroundColor: kRed,
        ),
      );
      setState(() {
        loading = false;
      });
    }
  }
}