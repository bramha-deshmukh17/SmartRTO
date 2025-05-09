import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utility/constants.dart';
import '../../utility/round_button.dart';
import '../../utility/user_input.dart';
class GenerateGrievance extends StatefulWidget {
  final String fineid;

  const GenerateGrievance({super.key, required this.fineid});

  @override
  State<GenerateGrievance> createState() => _GenerateGrievanceState();
}

class _GenerateGrievanceState extends State<GenerateGrievance> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String userPhone;
  final TextEditingController _fineNoController = TextEditingController();
  final TextEditingController _grievance = TextEditingController();

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  final _focusNodeSecond = FocusNode();

  void _showBottomSheet(BuildContext context) {
    //bottom sheet to generate the grievance
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              UserInput(
                readonly: true,
                controller: _fineNoController,
                hint: "Fine No.*",
                keyboardType: TextInputType.text,
                submit: (_) {
                  // Move focus to the second TextField
                  FocusScope.of(context).requestFocus(_focusNodeSecond);
                },
              ),
              kBox,
              UserInput(
                controller: _grievance,
                focusNode: _focusNodeSecond,
                hint: "Description*",
                keyboardType: TextInputType.text,
                maxlines: 5,
                textAlignment: TextAlign.start,
                submit: (value) {
                  FocusScope.of(context).unfocus(); // Dismiss the keyboard
                },
              ),
              kBox,
              RoundButton(
                  onPressed: () {
                    //generate grievance against the fine issued and store in the firebase
                    _fireStore.collection('grievance').add({
                      'fineno': _fineNoController.text,
                      'grievance': _grievance.text,
                      'date': FieldValue.serverTimestamp(),
                      'reply': 'NA',
                      'by': userPhone
                    });
                    Navigator.pop(context);
                  },
                  text: "Submit")
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    userPhone = _auth.currentUser!.phoneNumber ?? '';
    // Initialize the controller with widget.fineid
    _fineNoController.text = widget.fineid;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showBottomSheet(context),
      child: Text('Add Grievance'),
    );
  }
}
