import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drop_down_search_field/drop_down_search_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_rto/OfficialsPage/Utility/FinesList.dart';

import '../Utility/Constants.dart';
import '../Utility/RoundButton.dart';
import '../Utility/UserInput.dart';
import 'OfficerProfile.dart';
import 'Utility/CapturePhoto.dart';
import 'ConfirmFine.dart';
import 'Utility/SearchDropDown.dart';

class GenerateFines extends StatefulWidget {
  static const String id = 'generateFines';
  const GenerateFines({super.key});

  @override
  State<GenerateFines> createState() => _GenerateFinesState();
}

class _GenerateFinesState extends State<GenerateFines> {
  final TextEditingController _numberController = TextEditingController();
  Map<String, int> selectedFines = <String, int>{};

  final TextEditingController _dropdownSearchFieldController =
      TextEditingController();
  SuggestionsBoxController _suggestionBoxController =
      SuggestionsBoxController();

  String? vehicleNumber;
  int total = 0;
  String? numberError = null;
  bool listError = false;
  String? numberPlate, imgUrl;
  late Map<String, int> finesAndPenalties = {};

  Future<Map<String, int>> fetchFinesFromFirestore() async {
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: kAppBarTitle,
          backgroundColor: kPrimaryColor,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: kBackArrow,
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, Profile.id);
              },
              icon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Icon(
                  Icons.person,
                  color: kWhite,
                ),),
            ),
          ],
        ),
        body: Scrollbar(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 70.0),
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
                      onPressed: () {
                        if (verifyNumber(_numberController.text.toUpperCase()) &&
                            selectedFines.isNotEmpty) {
                          numberError = null;
                          listError = false;

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
      ),
    );
  }

  bool verifyNumber(String number) {
    RegExp regExp = RegExp(r'([A-Z]{2})(\d{1,2})([A-Z]{2})(\d{1,4})');
    Match? match = regExp.firstMatch(number);

    if (match != null) {
      //divided in 4 group to easily format the number
      String stateCode = match.group(1)!;
      String districtCode = match.group(2)!;
      String letterCode = match.group(3)!;
      String numericCode = match.group(4)!;

      //add zeros from left to have full 10 digit number plate
      String formattedDistrictCode = districtCode.padLeft(2, '0');
      String formattedNumericCode = numericCode.padLeft(4, '0');

      String formattedPlate =
          '$stateCode$formattedDistrictCode$letterCode$formattedNumericCode';

      if (regExp.hasMatch(formattedPlate)) {
        setState(() {
          numberPlate = formattedPlate;
        });
        return true;
      }
    }

    return false;
  }
}
