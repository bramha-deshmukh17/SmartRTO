import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../Utility/Constants.dart';
import 'VehicleDetails.dart'; // Import the new details screen

class ViewVehicle extends StatefulWidget {
  static const String id = "UserVehicle";
  const ViewVehicle({super.key});

  @override
  State<ViewVehicle> createState() => _ViewVehicleState();
}

class _ViewVehicleState extends State<ViewVehicle> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String userPhone;

  @override
  void initState() {
    super.initState();
    userPhone = _auth.currentUser!.phoneNumber ?? ''; // Get the current user's phone
  }

  // Fetch the user's vehicles from Firestore
  Stream<QuerySnapshot> _getUserVehicles() {
    return _firestore
        .collection('cars')
        .where('contact', isEqualTo: userPhone) // Assuming 'contact' stores user phone
        .snapshots();
  }

  Widget _getIcon(String type) {
    switch (type) {
      case 'TW':
        return Icon(FontAwesomeIcons.motorcycle);
      case 'FW':
        return Icon(FontAwesomeIcons.car);
      case 'bus':
        return Icon(FontAwesomeIcons.bus);
      case 'truck':
        return Icon(FontAwesomeIcons.truck);
      default:
        return Icon(FontAwesomeIcons.ban);
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: kBackArrow,
          ),
          title: kAppBarTitle,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: _getUserVehicles(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Error loading vehicles.'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No vehicles found.'));
              }

              // Display the list of vehicles
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var doc = snapshot.data!.docs[index];
                  var vehicle = doc.data() as Map<String, dynamic>;

                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      leading: _getIcon(vehicle['type']),
                      title: Text(vehicle['model'] ?? 'Unknown Model'),
                      subtitle: Text('License: ${doc.id}'),
                      onTap: () {
                        // Navigate to the vehicle details screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VehicleDetails(vehicle: vehicle, number: doc.id),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),

    );
  }
}
