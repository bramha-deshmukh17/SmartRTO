import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:smart_rto/Utility/RoundButton.dart';
import 'package:smart_rto/Utility/UserInput.dart';

import 'HomeScreen.dart';
import '../Utility/Constants.dart';

class OfficerLogin extends StatefulWidget {
  static const String id = 'OfficerLogin';
  const OfficerLogin({super.key});

  @override
  State<OfficerLogin> createState() => _OfficerLoginState();
}

class _OfficerLoginState extends State<OfficerLogin> {
  final _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  String? errorEmail, errorPass;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: kBackArrow,
          ),
          backgroundColor: kPrimaryColor,
          title: kAppBarTitle,
        ),
        body: ModalProgressHUD(
          inAsyncCall: loading,
          progressIndicator: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(kSecondaryColor), // Set custom color
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                UserInput(
                  controller: emailController,
                  hint: 'Enter Email',
                  keyboardType: TextInputType.emailAddress,
                  errorText: errorEmail,
                ),
                const SizedBox(height: 25.0),
                UserInput(
                  controller: passController,
                  hint: 'Enter Password',
                  obscureText: true,
                  keyboardType: TextInputType.emailAddress,
                  errorText: errorPass,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                RoundButton(
                  onPressed: () {
                    if (validateEmailAndPassword(
                        emailController.text, passController.text)) {
                      signInWithEmailAndPassword();
                    }
                  },
                  text: 'Login',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signInWithEmailAndPassword() async {
    setState(() {
      loading = true;
    });
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim(),
      );
      Navigator.pushNamedAndRemoveUntil(
        context,
        HomeScreen.id, // Navigate to HomeScreen
        (Route<dynamic> route) => false, // Remove all previous routes
      );
      // Successful login
      print('User signed in: ${userCredential.user?.email}');
      // Navigate to home screen or show success message
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wrong login credentials.')),
      );
      print(e);
    }
    setState(() {
      loading = false;
    });
  }

  bool validateEmailAndPassword(String email, String pass) {
    setState(() {
      errorEmail = null; // Resetting error messages
      errorPass = null;

      // Email validation
      String emailPattern =
          r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
      RegExp emailRegExp = RegExp(emailPattern);
      if (email.isEmpty) {
        errorEmail = 'Email cannot be empty';
      } else if (!emailRegExp.hasMatch(email)) {
        errorEmail = 'Invalid email format';
      }

      // Password validation
      if (pass.isEmpty) {
        errorPass = 'Password cannot be empty';
      } else if (pass.length < 6) {
        errorPass = 'Password must be at least 6 characters long';
      }
    });

    // Return true if no errors, false otherwise
    return errorEmail == null && errorPass == null;
  }
}
