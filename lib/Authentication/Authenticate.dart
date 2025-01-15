import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/Welcome.dart';
import '/UserPages/HomePage.dart';
import '../OfficialsPage/HomeScreen.dart';

class Authenticate extends StatelessWidget {
  static const String id = 'Authenticate';

  const Authenticate({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Loading screen
        } else if (snapshot.hasData) {
          User? user = snapshot.data;

          // Check for sign-in method
          bool isMobileAuth = false;
          for (var provider in user?.providerData ?? []) {
            if (provider.providerId == 'phone') {
              isMobileAuth = true;
              break;
            }
          }
          if (isMobileAuth) {
            // Redirect to HomeScreen if logged in via mobile auth
            return HomePage();
          } else {
            // Redirect to HomePage if logged in via email & password
            return HomeScreen();
          }
        } else {
          // No user signed in, show the Welcome screen
          return Welcome();
        }
      },
    );
  }
}
