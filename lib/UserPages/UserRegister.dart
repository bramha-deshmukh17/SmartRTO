import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:smart_rto/Utility/Constants.dart';
import 'package:smart_rto/Utility/RoundButton.dart';
import 'package:smart_rto/Utility/UserInput.dart';
import 'HomePage.dart';
import '../Utility/OTPField.dart';

class UserRegister extends StatefulWidget {
  static const String id = 'userRegister';
  const UserRegister({super.key});

  @override
  State<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  late PhoneAuthCredential credential;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId = '',
      buttonText = 'Register';
  bool otpEnable = false,
      loading = false;
      String? mobileError;

  bool _validateMobile(String number) {
    if (!number.isEmpty && number.length >= 10) {
      setState(() {
        mobileError = null;
      });
      return true;
    }
    else {
      setState(() {
        mobileError = "Enter valid Mobile number";
      });
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            backgroundColor: kPrimaryColor,
            title: kAppBarTitle,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: kBackArrow,
            ),
          ),
          body: ModalProgressHUD(
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
                const SizedBox(height: 10.0,),
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

  void _sendOTP() async {
    setState(() {
      loading = true;
      otpEnable = true;
      buttonText = 'Verify OTP';
    });
    await _auth.verifyPhoneNumber(
      phoneNumber: '+91${_phoneController.text}',
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
    setState(() {
      loading = false;
    });
  }

  void _verifyOTP() async {
    setState(() {
      loading = true;
    });

    String smsCode = _otpController.text.trim();

    try {
      credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: smsCode,
      );

      try {
        await _auth.signInWithCredential(credential);

        // Reference to Firestore instance
        final firestore = FirebaseFirestore.instance;

        String phoneNumber = '+91${_phoneController.text.trim()}';

        // Check if user is already registered in the 'users' collection
        DocumentSnapshot userDoc = await firestore.collection('users').doc(phoneNumber).get();

        if (!userDoc.exists) {
          // If the document doesn't exist, create a new document for the user
          try {
            await firestore.collection('users').doc(phoneNumber).set({
              'mobile': phoneNumber,
              'name': null,
              'email': null,
              'img': null,
            });

            print('Document created successfully!');
          } catch (e) {
            print('Error creating document: $e');
          }
        } else {
          // If the user is already registered, you can log this or handle accordingly
          print('User is already registered.');
        }

        // Navigate to HomePage after successful login or registration
        Navigator.pushNamedAndRemoveUntil(
          context,
          HomePage.id, // Navigate to HomeScreen
              (Route<dynamic> route) => false, // Remove all previous routes
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to verify. Try after some time.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to verify OTP. Try after some time')),
      );
      setState(() {
        loading = false;
      });
    }
  }

}