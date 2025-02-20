import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

const Color kPrimaryColor = Color(0xFF000080);
const Color kSecondaryColor = Color(0xFF1f87a0);
const Color kOutline = Color(0xFFd5ecf4);

const Color kWhite = Colors.white;
const Color kBlack = Colors.black;
const Color kRed = Colors.red;
const Color kBlue = Colors.blue;
const Color kGreen = Colors.green;
const Color kGrey = Colors.grey;

const String kFamily = 'InriaSans';

//app bar text
const Text kAppBarTitle = Text(
  'Smart RTO',
  style: TextStyle(
    fontFamily: 'InriaSans',
    fontWeight: FontWeight.w500,
    fontSize: 24.0,
    color: kWhite,
  ),
);

// app bar back icon
const Icon kBackArrow = Icon(
  FontAwesomeIcons.arrowLeft,
  color: kWhite,
  size: 20.0,
);

const kBox = SizedBox(
  height: 15.0,
);

InputDecoration kDropdown(String label) => InputDecoration(
      labelText: label,
      hintText: "Select $label",
      labelStyle: TextStyle(color: kBlack),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: kSecondaryColor, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
            color: kSecondaryColor, width: 1.0), // Default state
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
            color: kSecondaryColor, width: 2.0), // Focused state
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide:
            const BorderSide(color: Colors.red, width: 2.0), // Error state
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(
            color: Colors.red, width: 2.0), // Error focused state
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
    );


const kListHeaders = SizedBox(
  width: 280.0,
  child: ListTile(
    leading: Text(
      'Fine',
      style: TextStyle(
        color: kBlack,
        fontSize: 15.0,
        wordSpacing: 0.01,
        fontFamily: 'InriaSans',
      ),
    ),
    trailing: Text(
      'Penalty',
      style: TextStyle(
        color: kBlack,
        fontSize: 15.0,
        wordSpacing: 0.01,
        fontFamily: 'InriaSans',
      ),
    ),
  ),
);

const kTextStyle = TextStyle(color: kWhite, fontSize: 16.0,);