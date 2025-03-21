import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/material.dart';
import '../../utility/appbar.dart';
import '../utility/fines_list.dart';

import '../../utility/constants.dart';
import '../../utility/round_button.dart';
import '../../utility/user_input.dart';
import '../utility/capture_photo.dart';
import 'confirm_fine.dart';
import '../../utility/search_dropdown.dart';

class GenerateFines extends StatefulWidget {
  static const String id = 'officer/fine/generate';
  const GenerateFines({super.key});

  @override
  State<GenerateFines> createState() => _GenerateFinesState();
}

class _GenerateFinesState extends State<GenerateFines> {
  final TextEditingController _numberController = TextEditingController();
  Map<String, int> selectedFines = <String, int>{};

  final TextEditingController _dropdownSearchFieldController =
      TextEditingController();
  final SuggestionsBoxController _suggestionBoxController =
      SuggestionsBoxController();

  String? vehicleNumber;
  int total = 0;
  String? numberError = null;
  bool listError = false;
  String? numberPlate, imgUrl;
  late Map<String, int> finesAndPenalties = {};

  Future<Map<String, int>> fetchFinesFromFirestore() async {
    // Fetch fines from Firestore
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('finesdata')
          .doc('penalties')
          .get();
      finesAndPenalties = Map<String, int>.from(snapshot.data()!);
      return finesAndPenalties;
    } catch (e) {
      print('Error fetching fines: $e');
      return {};
    }
  }

  void initState() {
    super.initState();
    fetchFines();
  }

  void fetchFines() async {
    Map<String, int> fines = await fetchFinesFromFirestore();
    setState(() {
      finesAndPenalties = fines;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(title: 'Generate Fine', isBackButton: true, displayOfficerProfile: true),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 70.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UserInput(
                    controller: _numberController,
                    hint: 'Enter Vehicle No.',
                    keyboardType: TextInputType.text,
                    errorText: numberError,
                    maxLength: 10,
                  ), //Vehicle number
                  kBox,
                  SearchDropDown(
                    dropdownSearchFieldController:
                        _dropdownSearchFieldController,
                    suggestionBoxController: _suggestionBoxController,
                    finesAndPenalties: finesAndPenalties,
                    onSelectedFine: (String fine, int amount) {
                      setState(() {
                        selectedFines[fine] = amount;
                      });
                    },
                    onTotalChanged: (int amount) {
                      setState(() {
                        total += amount;
                      });
                    },
                  ),//Search dropdown for fine list
                  kBox,
                  if (listError)
                    const SizedBox(
                      height: 15.0,
                      child: Text(
                        'Select at least one fine',
                        style: TextStyle(color: kRed),
                      ),
                    ),//Show fine not selected error
                  kListHeaders,
                  FineList(selectedFines: selectedFines),//selected fines list
                  kBox,
                  SizedBox(
                    width: 250.0,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        'Total: ₹${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontFamily: 'InriaSans',
                        ),
                      ),
                    ),
                  ),//SHow total fine
                  kBox,
                  CaptureImage(
                    captureImage: (String imageUrl) {
                      setState(() {
                        imgUrl = imageUrl;
                      });
                    },
                  ),
                  kBox,
                  RoundButton(
                    text: 'Generate',
                    onPressed: () async {
                      bool isValidNumber = await verifyNumber(_numberController.text.toUpperCase());
                      if (isValidNumber &&
                          selectedFines.isNotEmpty) {
                        numberError = null;
                        listError = false;

                        //send data to confirm screen
                        Navigator.pushNamed(context, Confirmfine.id,
                            arguments: {
                              'total': total,
                              'fines': selectedFines,
                              'number': numberPlate,
                              'imgUrl': imgUrl,
                            });
                      } else {
                        setState(() {
                          listError = selectedFines.isEmpty;
                          numberError = _numberController.text.isEmpty
                              ? 'Enter valid number'
                              : 'Please fill this field';
                        });
                      }
                    },
                  ),//Generate fine button
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> verifyNumber(String number) async {
    //here we have created 4 groups to match the number plate
    //eg: MH12AB1234
    //group 1: MH
    //group 2: 12
    //group 3: AB
    //group 4: 1234
    //group 1 and 3 are alphabets and group 2 and 4 are numbers
    //we have used regex to match the number plate
    RegExp regExp = RegExp(r'([A-Z]{2})(\d{1,2})([A-Z]{2})(\d{1,4})');
    Match? match = regExp.firstMatch(number);

    if (match != null) {
      // Divide into 4 groups for easier formatting
      String stateCode = match.group(1)!;
      String districtCode = match.group(2)!;
      String letterCode = match.group(3)!;
      String numericCode = match.group(4)!;

      // Add zeros from left to have full 10-digit number plate
      String formattedDistrictCode = districtCode.padLeft(2, '0');
      String formattedNumericCode = numericCode.padLeft(4, '0');

      String formattedPlate =
          '$stateCode$formattedDistrictCode$letterCode$formattedNumericCode';

      if (regExp.hasMatch(formattedPlate)) {
        // Check Firestore for the formatted plate
        try {
          DocumentSnapshot<Map<String, dynamic>> docSnapshot = await FirebaseFirestore
              .instance
              .collection('cars')
              .doc(formattedPlate)
              .get();

          if (docSnapshot.exists) {
            // Vehicle found
            setState(() {
              numberPlate = formattedPlate;
            });
            return true; // Plate exists in the database
          } else {
            // Show Snackbar for vehicle not found
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Vehicle not found in the database.'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
              ),
            );
          }
        } catch (e) {
          // Log error (do not show Snackbar for errors)
          print('Error checking Firestore: $e');
        }
      }
    }
    return false; // Number plate not found or invalid format
  }

}
