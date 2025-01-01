import 'package:flutter/material.dart';
import 'dart:async';

import 'Utility/Constants.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      // Navigate to your main app screen
      Navigator.pushReplacementNamed(context, '/authenticate');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white, // Customize background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('images/logo.png') as ImageProvider,
            ), // Splash logo
            kBox,
            CircularProgressIndicator(color: kSecondaryColor,), // Loader
            kBox,
            Text(
              'Loading...',
              style: TextStyle(color: kGrey),
            ),
          ],
        ),
      ),
    );
  }
}
