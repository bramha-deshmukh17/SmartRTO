import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../Utility/Appbar.dart';
import '../../Welcome.dart';
import '../../Utility/Constants.dart';
import 'EditProfile.dart'; // Ensure constants like kPrimaryColor are defined

class UserProfile extends StatefulWidget {
  static const String id = "UserProfile";

  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? userMobile, userMail, userName, userImg;
  bool isLoading = true; // Loading state

  Future<void> getUserData() async {
    try {
      User? user = _auth.currentUser; // Get the current user
      userMobile = user?.phoneNumber; // Fetch the mobile number
      print(userMobile);

      if (userMobile != null) {
        DocumentSnapshot querySnapshot =
            await _firestore.collection('users').doc(userMobile).get();

        if (querySnapshot.exists) {
          Map<String, dynamic> documentData =
              querySnapshot.data() as Map<String, dynamic>;

          setState(() {
            userImg = documentData['img'];
            userMail = documentData['email'];
            userName = documentData['name'];
            isLoading = false; // Data loaded
          });
        } else {
          setState(() {
            isLoading = false; // No data found
          });
        }
      } else {
        setState(() {
          isLoading = false; // User not signed in
        });
      }
    } catch (e) {
      print("Error while fetching user data: $e");
      setState(() {
        isLoading = false; // Stop loading even on error
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(
        title: 'Profile',
        isBackButton: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kSecondaryColor),
              ), // Show loading indicator
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    kBox,
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: userImg != null
                          ? NetworkImage(userImg!)
                          : const AssetImage('images/images.png')
                              as ImageProvider,
                    ),
                    kBox,
                    Text(
                      userName ?? 'Name not available', // Handle null safely
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'InriaSans',
                      ),
                    ),
                    kBox,
                    Text(
                      userMail ?? 'Email not available', // Handle null safely
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    Text(
                      userMobile ??
                          'Phone number not available', // Handle null safely
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    kBox,
                    ElevatedButton.icon(
                      icon: const Icon(
                        FontAwesomeIcons.pen,
                        size: 18,
                        color: kWhite,
                      ),
                      label: const Text(
                        "Edit Profile",
                        style: kTextStyle,
                      ),
                      onPressed: () async {
                        final updatedData = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditUserProfile(
                              userName: userName ?? '',
                              userEmail: userMail ?? '',
                              userImg: userImg ?? '',
                              userMobile: userMobile ?? '',
                            ),
                          ),
                        );

                        if (updatedData != null) {
                          setState(() {
                            userName = updatedData['userName'];
                            userMail = updatedData['userEmail'];
                            userImg = updatedData['userImg'];
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kSecondaryColor,
                        minimumSize: const Size(200, 45),
                      ),
                    ),
                    kBox,
                    ElevatedButton.icon(
                      icon: const Icon(
                        FontAwesomeIcons.signOut,
                        size: 18,
                        color: kWhite,
                      ),
                      label: const Text(
                        "Logout",
                        style: kTextStyle,
                      ),
                      onPressed: logout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size(200, 45),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> logout() async {
    await _auth.signOut(); // Sign out the user

    // Clear the app stack and navigate to the welcome screen
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
          builder: (context) =>
              Welcome()), // Replace with your welcome screen widget
      (Route<dynamic> route) => false, // Remove all previous routes
    );
  }
}
