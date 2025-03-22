import 'package:flutter/material.dart';

class FormData {
  //form data of license application
  bool isDrivingApplication = false;

  String? selectedState;
  String? selectedDistrict;
  final TextEditingController pinCodeController = TextEditingController();
  final FocusNode pinCodeFocus = FocusNode();

  // Personal Details
  final TextEditingController fullNameController = TextEditingController();
  final FocusNode fullNameFocus = FocusNode();

  String? selectedRelation;
  final TextEditingController relativeFullNameController =
      TextEditingController();
  final FocusNode relativeFullNameFocus = FocusNode();

  String? selectedGender;
  DateTime? selectedDateOfBirth;

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

  // Declaration Answers
  bool? declarationAnswer1;
  bool? declarationAnswer2;
  bool? declarationAnswer3;
  bool? declarationAnswer4;
  bool? declarationAnswer5;
  bool? declarationAnswer6;

  // Declaration Checkbox
  bool declarationChecked = false;

  // Class of Vehicle
  List<String> selectedVehicleClasses = [];

  // Organ Donation
  bool? donateOrgan;
  bool acknowledgement = false;

  //photo and sign
  String? photo, signature;
  String? aadhaarPdf, billPdf, selfie, paymentId;

  DateTime? payementDate;

  // Add this map to your existing class
  final Map<String, String?> fieldErrors = {};

  void clearErrors() {
    fieldErrors.clear();
  }

  // Convert FormData to a Map of learning license
  Map<String, dynamic> toMap() {
    return {
      'selectedState': selectedState,
      'selectedDistrict': selectedDistrict,
      'pinCode': pinCodeController.text,
      'fullName': fullNameController.text,
      'selectedRelation': selectedRelation,
      'relativeFullName': relativeFullNameController.text,
      'selectedGender': selectedGender,
      'selectedDateOfBirth': selectedDateOfBirth?.toIso8601String(),
      'placeOfBirth': placeOfBirthController.text,
      'selectedCountryOfBirth': selectedCountryOfBirth,
      'selectedQualification': selectedQualification,
      'selectedBloodGroup': selectedBloodGroup,
      'landline': landlineController.text,
      'email': emailController.text,
      'applicantMobile': applicantMobileController.text,
      'emergencyMobile': emergencyMobileController.text,
      'identityMark1': identityMark1Controller.text,
      'identityMark2': identityMark2Controller.text,
      'presentState': presentState,
      'presentDistrict': presentDistrict,
      'presentTehsil': presentTehsilController.text,
      'presentVillage': presentVillageController.text,
      'presentAddress': presentAddressController.text,
      'presentLandmark': presentLandmarkController.text,
      'presentPincode': presentPincodeController.text,
      'sameAsPresent': sameAsPresent,
      'permanentState': permanentState,
      'permanentDistrict': permanentDistrict,
      'permanentTehsil': permanentTehsilController.text,
      'permanentVillage': permanentVillageController.text,
      'permanentAddress': permanentAddressController.text,
      'permanentLandmark': permanentLandmarkController.text,
      'permanentPincode': permanentPincodeController.text,
      'declarationAnswer1': declarationAnswer1,
      'declarationAnswer2': declarationAnswer2,
      'declarationAnswer3': declarationAnswer3,
      'declarationAnswer4': declarationAnswer4,
      'declarationAnswer5': declarationAnswer5,
      'declarationAnswer6': declarationAnswer6,
      'declarationChecked': declarationChecked,
      'selectedVehicleClasses': selectedVehicleClasses,
      'donateOrgan': donateOrgan,
      'acknowledgement': acknowledgement,
      'photo': photo,
      'signature': signature,
      'aadhaarPdf': aadhaarPdf,
      'billPdf': billPdf,
      'paymentId': paymentId,
      'payementDate': payementDate?.toIso8601String(),
      'examResult': null,
      'approved': false,
    };
  }

  // Convert FormData to a Map of driving license
  Map<String, dynamic> toMapDl() {
    return {
      'selectedState': selectedState,
      'selectedDistrict': selectedDistrict,
      'pinCode': pinCodeController.text,
      'fullName': fullNameController.text,
      'selectedRelation': selectedRelation,
      'relativeFullName': relativeFullNameController.text,
      'selectedGender': selectedGender,
      'selectedDateOfBirth': selectedDateOfBirth?.toIso8601String(),
      'placeOfBirth': placeOfBirthController.text,
      'selectedCountryOfBirth': selectedCountryOfBirth,
      'selectedQualification': selectedQualification,
      'selectedBloodGroup': selectedBloodGroup,
      'landline': landlineController.text,
      'email': emailController.text,
      'applicantMobile': applicantMobileController.text,
      'emergencyMobile': emergencyMobileController.text,
      'identityMark1': identityMark1Controller.text,
      'identityMark2': identityMark2Controller.text,
      'presentState': presentState,
      'presentDistrict': presentDistrict,
      'presentTehsil': presentTehsilController.text,
      'presentVillage': presentVillageController.text,
      'presentAddress': presentAddressController.text,
      'presentLandmark': presentLandmarkController.text,
      'presentPincode': presentPincodeController.text,
      'sameAsPresent': sameAsPresent,
      'permanentState': permanentState,
      'permanentDistrict': permanentDistrict,
      'permanentTehsil': permanentTehsilController.text,
      'permanentVillage': permanentVillageController.text,
      'permanentAddress': permanentAddressController.text,
      'permanentLandmark': permanentLandmarkController.text,
      'permanentPincode': permanentPincodeController.text,
      'declarationAnswer1': declarationAnswer1,
      'declarationAnswer2': declarationAnswer2,
      'declarationAnswer3': declarationAnswer3,
      'declarationAnswer4': declarationAnswer4,
      'declarationAnswer5': declarationAnswer5,
      'declarationAnswer6': declarationAnswer6,
      'declarationChecked': declarationChecked,
      'selectedVehicleClasses': selectedVehicleClasses,
      'donateOrgan': donateOrgan,
      'acknowledgement': acknowledgement,
      'photo': photo,
      'signature': signature,
      'aadhaarPdf': aadhaarPdf,
      'billPdf': billPdf,
      'paymentId': paymentId,
      'payementDate': payementDate?.toIso8601String(),
      'selfie': selfie,
      'slot': slot_id,
      'slot_no': slot_no,
      'examResult': null,
      'approved': false,
    };
  }

  String? receiptId, slot_no, slot_id;
}
