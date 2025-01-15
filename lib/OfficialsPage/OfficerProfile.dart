import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/Utility/Constants.dart';

import '../Welcome.dart';

class Profile extends StatefulWidget {
  static const String id = 'OfficeProfile';
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  // Officer data
  String officerName = '', officerEmail = '', officerDesignation = '', officerPhone = '', officerId = '';
  String profileImageUrl = '';
  late DateTime joiningDate;


  // Fetch officer details from Firestore
  Future<void> getOfficerData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      setState(() {
        officerEmail = user.email!;
      });

      try {
        // Fetch the officer's data using the email
        QuerySnapshot officerSnapshot = await _firestore
            .collection('officials')
            .where('email', isEqualTo: officerEmail)
            .get();


          // Assuming that email is unique, we can take the first document
        DocumentSnapshot officerDoc = officerSnapshot.docs.first;
        Map<String, dynamic> data = officerDoc.data() as Map<String, dynamic>;

          setState(() {
            officerId = officerDoc.id;
            officerName = data['name'] ?? 'N/A';
            officerEmail = data['email'] ?? 'N/A';
            officerDesignation = data['post'] ?? 'N/A';
            profileImageUrl = data['photoUrl']; // Placeholder image if URL is empty
            officerPhone = data['phoneNumber'] ?? 'N/A';
            joiningDate = data['joiningDate'].toDate();
          });

      } catch (e) {
        print('Error fetching officer data: $e');
      }
    } else {
      print('No user is currently logged in.');
    }
  }


  @override
  void initState() {
    super.initState();
    getOfficerData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: kAppBarTitle,
        backgroundColor: kPrimaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: kBackArrow,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: officerName.isEmpty
            ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(kSecondaryColor),))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(profileImageUrl),
                    ),
                  ),
                  kBox,
                  Center(
                    child: Text(
                      officerName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  kBox,
                  Center(
                    child: Text(
                      officerDesignation,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const Divider(height: 40, thickness: 1),
                  kBox,
                  ListTile(
                    leading: const Icon(Icons.badge, color: kSecondaryColor),
                    title: const Text(
                      'ID',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(officerId),
                  ),
                  ListTile(
                    leading: const Icon(Icons.email, color: kSecondaryColor),
                    title: const Text(
                      'Email',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(officerEmail),
                  ),
                  ListTile(
                    leading: const Icon(Icons.phone, color: kSecondaryColor),
                    title: const Text(
                      'Phone',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(officerPhone),
                  ),
                  ListTile(
                    leading: const Icon(Icons.calendar_today, color: kSecondaryColor),
                    title: const Text(
                      'Joined on',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(_formatDate(joiningDate)),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kSecondaryColor,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed:logout,
                    child: const Text('Log Out', style: TextStyle(color: kWhite),),
                  ),
                ],
              ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

  Future<void> logout() async {
    await _auth.signOut(); // Sign out the user

    // Clear the app stack and navigate to the welcome screen
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => Welcome()), // Replace with your welcome screen widget
          (Route<dynamic> route) => false, // Remove all previous routes
    );
  }
}
