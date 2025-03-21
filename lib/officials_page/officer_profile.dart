import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utility/appbar.dart';
import '../utility/constants.dart';
import '../welcome.dart';

class Profile extends StatefulWidget {
  static const String id = 'office/profile';
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  DocumentSnapshot? officerDoc;

  Future<void> getOfficerData() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        QuerySnapshot officerSnapshot = await _firestore
            .collection('officials')
            .where('email', isEqualTo: user.email)
            .get();

        setState(() {
          officerDoc = officerSnapshot.docs.first;
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
      appBar: Appbar(
        title: 'Profile',
        isBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: officerDoc == null
            ? const Center(child: CircularProgressIndicator(color: kSecondaryColor))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(officerDoc!['photoUrl']),
                    ),
                  ),
                  kBox,
                  Center(
                    child: Text(
                      officerDoc!['name'] ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  kBox,
                  Center(
                    child: Text(
                      officerDoc!['post'] ?? 'N/A',
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
                    subtitle: Text(officerDoc!.id),
                  ),
                  ListTile(
                    leading: const Icon(Icons.email, color: kSecondaryColor),
                    title: const Text(
                      'Email',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(officerDoc!['email'] ?? 'N/A'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.phone, color: kSecondaryColor),
                    title: const Text(
                      'Phone',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(officerDoc!['phoneNumber'] ?? 'N/A'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.calendar_today, color: kSecondaryColor),
                    title: const Text(
                      'Joined on',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(_formatDate(officerDoc!['joiningDate'].toDate())),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kSecondaryColor,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: logout,
                    child: const Text('Log Out', style: TextStyle(color: kWhite)),
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
    await _auth.signOut();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => Welcome()),
      (Route<dynamic> route) => false,
    );
  }
}
