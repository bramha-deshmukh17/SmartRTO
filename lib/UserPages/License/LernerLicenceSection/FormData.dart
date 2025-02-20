import 'package:flutter/material.dart';

class FormData {
  // Personal Details
  final TextEditingController pinCodeController = TextEditingController();
  final FocusNode pinCodeFocus = FocusNode();

  final TextEditingController fullNameController = TextEditingController();
  final FocusNode fullNameFocus = FocusNode();

  String? selectedRelation;
  final TextEditingController relativeFullNameController =
      TextEditingController();
  final FocusNode relativeFullNameFocus = FocusNode();

  String? selectedGender;
  DateTime? selectedDateOfBirth;

  void updateDateOfBirth(DateTime val) {
    selectedDateOfBirth = val;
  }

  final TextEditingController placeOfBirthController = TextEditingController();
  final FocusNode placeOfBirthFocus = FocusNode();

  String? selectedCountryOfBirth;

  String? selectedQualification;
  String? selectedBloodGroup;

  final TextEditingController landlineController = TextEditingController();
  final FocusNode landlineFocus = FocusNode();

  final TextEditingController emailController = TextEditingController();
  final FocusNode emailFocus = FocusNode();

  final TextEditingController applicantMobileController =
      TextEditingController();
  final FocusNode applicantMobileFocus = FocusNode();

  final TextEditingController emergencyMobileController =
      TextEditingController();
  final FocusNode emergencyMobileFocus = FocusNode();

  final TextEditingController identityMark1Controller = TextEditingController();
  final FocusNode identityMark1Focus = FocusNode();

  final TextEditingController identityMark2Controller = TextEditingController();
  final FocusNode identityMark2Focus = FocusNode();

  // Address - Present
  String? presentState;
  String? presentDistrict;

  final TextEditingController presentTehsilController = TextEditingController();
  final FocusNode presentTehsilFocus = FocusNode();

  final TextEditingController presentVillageController =
      TextEditingController();
  final FocusNode presentVillageFocus = FocusNode();

  final TextEditingController presentAddressController =
      TextEditingController();
  final FocusNode presentAddressFocus = FocusNode();

  final TextEditingController presentLandmarkController =
      TextEditingController();
  final FocusNode presentLandmarkFocus = FocusNode();

  final TextEditingController presentPincodeController =
      TextEditingController();
  final FocusNode presentPincodeFocus = FocusNode();

  // Address - Permanent
  bool sameAsPresent = false;
  String? permanentState;
  String? permanentDistrict;

  final TextEditingController permanentTehsilController =
      TextEditingController();
  final FocusNode permanentTehsilFocus = FocusNode();

  final TextEditingController permanentVillageController =
      TextEditingController();
  final FocusNode permanentVillageFocus = FocusNode();

  final TextEditingController permanentAddressController =
      TextEditingController();
  final FocusNode permanentAddressFocus = FocusNode();

  final TextEditingController permanentLandmarkController =
      TextEditingController();
  final FocusNode permanentLandmarkFocus = FocusNode();

  final TextEditingController permanentPincodeController =
      TextEditingController();
  final FocusNode permanentPincodeFocus = FocusNode();

  // Duration of stay
  final TextEditingController durationYearsController = TextEditingController();
  final TextEditingController durationMonthsController =
      TextEditingController();

  // Declaration Answers
  bool declarationAnswer1 = false;
  bool declarationAnswer2 = false;
  bool declarationAnswer3 = false;
  bool declarationAnswer4 = false;
  bool declarationAnswer5 = false;
  bool declarationAnswer6 = false;

  // Class of Vehicle
  List<String> selectedVehicleClasses = [];

  // Organ Donation
  String? donateOrgan;

  // Declaration Checkbox
  bool declarationChecked = false;

  String? selectedState;
  String? selectedDistrict;
}
