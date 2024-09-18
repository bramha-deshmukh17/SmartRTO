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
const Text kAppBarTitle = Text('Smart RTO',
  style: TextStyle(
    fontFamily: 'InriaSans',
    fontWeight: FontWeight.w500,
    fontSize: 24.0,
    color: kWhite,
  ),
);

// app bar back icon
const Icon kBackArrow =  Icon(
  FontAwesomeIcons.arrowLeft,
  color: kWhite,
  size: 20.0,
);

