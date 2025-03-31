import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../utility/appbar.dart';
import '../../utility/constants.dart';
import '../../utility/round_button.dart';
import '../../utility/user_input.dart';
import 'vehicle_details.dart'; // Import the new details screen

class ViewVehicle extends StatefulWidget {
  static const String id = "user/vehicle";
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
    userPhone =
        _auth.currentUser!.phoneNumber ?? ''; // Get the current user's phone
  }

  // Fetch the user's vehicles from Firestore
  Stream<QuerySnapshot> _getUserVehicles() {
    //get the vehicle based on phone number of the user
    return _firestore
        .collection('cars')
        .where('contact',
            isEqualTo: userPhone) // Assuming 'contact' stores user phone
        .snapshots();
  }

  Widget _getIcon(String type) {
    //icon according to vehicle type
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
    return Scaffold(
      floatingActionButton: IconButton(
        icon: Icon(FontAwesomeIcons.plus),
        onPressed: () {
          _showBottomSheet(context);
        },
      ),
      appBar: Appbar(
        title: 'Vehicles',
        isBackButton: true,
        displayUserProfile: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _getUserVehicles(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: kSecondaryColor,
              ));
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
                          builder: (context) =>
                              VehicleDetails(vehicle: vehicle, number: doc.id),
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

  void _showBottomSheet(BuildContext context) {
    final TextEditingController registrationNumberController =
        TextEditingController();
    final TextEditingController chassisNumberController =
        TextEditingController();
    final FocusNode focusNodeSecond = FocusNode();

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Vehicle Registration Number Input (read-only)
              UserInput(
                controller: registrationNumberController,
                hint: "Vehicle Registration Number*",
                keyboardType: TextInputType.text,
                submit: (_) {
                  FocusScope.of(context).requestFocus(focusNodeSecond);
                },
              ),
              kBox,
              // Chassis Number Input
              UserInput(
                controller: chassisNumberController,
                focusNode: focusNodeSecond,
                hint: "Chassis Number*",
                keyboardType: TextInputType.text,
                submit: (value) {
                  FocusScope.of(context).unfocus();
                },
              ),
              kBox,
              // Submit Button
              RoundButton(
                onPressed: () async {
                  // Retrieve and trim inputs
                  final String registrationNo =
                      registrationNumberController.text.trim();
                  final String chassisNo = chassisNumberController.text.trim();

                  // Simple validation for non-empty values
                  if (registrationNo.isEmpty || chassisNo.isEmpty) {
                    // You can show a SnackBar or alert dialog if validation fails.
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: kRed,
                          content: Text("Please fill in all required fields.")),
                    );
                    return;
                  }

                  try {
                    // Query the Firestore collection 'cars' for matching document(s)
                    final QuerySnapshot querySnapshot = await FirebaseFirestore
                        .instance
                        .collection('cars')
                        .where('vehicle_number', isEqualTo: registrationNo)
                        .where('chassis_number', isEqualTo: chassisNo)
                        .get();

                    if (querySnapshot.docs.isNotEmpty) {
                      // Update the contact field for each matching document
                      for (var doc in querySnapshot.docs) {
                        await doc.reference.update({
                          'contact': userPhone, // new contact value
                        });
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: kGreen,
                            content: Text("Vehicle Added successfully.")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(backgroundColor: kRed, content: Text("No matching vehicle found.")),
                      );
                    }
                  } catch (e) {
                    // Handle any errors during query/update
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(backgroundColor: kRed, content: Text("An error occurred: $e")),
                    );
                  }
                  Navigator.pop(context);
                },
                text: "Submit",
              )
            ],
          ),
        );
      },
    );
  }
}
