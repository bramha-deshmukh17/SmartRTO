import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../Utility/Constants.dart';
import '../../../Utility/CustomRadioButtonGroup .dart';
import '../../../Utility/UserInput.dart';
import 'FormData.dart';

class FillApplicationForm extends StatefulWidget {
  final FormData formData;
  FillApplicationForm({required this.formData});

  @override
  _FillApplicationFormState createState() => _FillApplicationFormState();
}

class _FillApplicationFormState extends State<FillApplicationForm> {
  List<String> stateList = [];
  List<String> districtList = [];

  @override
  void initState() {
    super.initState();
    fetchStates();
  }

  // Fetch all states (document IDs from the 'states' collection)
  Future<void> fetchStates() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('states').get();
    List<String> states = snapshot.docs.map((doc) => doc.id).toList()..sort();
    setState(() {
      stateList = states;
    });
  }

  // Fetch districts for the selected state from its document
  Future<void> fetchDistricts(String state) async {
    DocumentSnapshot docSnapshot =
        await FirebaseFirestore.instance.collection('states').doc(state).get();
    if (docSnapshot.exists) {
      List<dynamic> districts = docSnapshot.get('districts');
      setState(() {
        districtList = districts.map((d) => d.toString()).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //State and District pincode
          // Dropdown for states/UTs
          kBox,
          DropdownButtonFormField<String>(
            decoration: kDropdown("State"),
            value: widget.formData.selectedState,
            items: stateList.map((state) {
              return DropdownMenuItem<String>(
                value: state,
                child: Text(state),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                widget.formData.selectedState = newValue;
                widget.formData.selectedDistrict =
                    null; // reset district selection
                districtList = [];
              });
              if (newValue != null) {
                fetchDistricts(newValue);
              }
            },
          ),
          kBox,

          // Dropdown for districts based on the selected state
          DropdownButtonFormField<String>(
            decoration: kDropdown("District"),
            value: widget.formData.selectedDistrict,
            items: districtList.map((district) {
              return DropdownMenuItem<String>(
                value: district,
                child: Text(district),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                widget.formData.selectedDistrict = newValue;
              });
            },
          ),
          kBox,

          //pincode
          UserInput(
            controller: widget.formData.pinCodeController,
            hint: "Enter Pincode",
            keyboardType: TextInputType.number,
            width: double.infinity,
            focusNode: widget.formData.pinCodeFocus,
            maxLength: 6,
            textAlignment: TextAlign.start,
            submit: (_) {
              // Move focus to the second TextField
              FocusScope.of(context)
                  .requestFocus(widget.formData.fullNameFocus);
            },
          ),
          kBox,

          //Personal details
          MyContainer(child: FillPersonalDetails(formData: widget.formData)),
          kBox,

          //Address details
          MyContainer(child: FillAddressDetails(formData: widget.formData)),
          kBox,

          //Vehicle class details
          MyContainer(child: FillVehicleClass(formData: widget.formData)),
          kBox,

          //Declaration Form
          MyContainer(child: FillDeclarationForm(formData: widget.formData)),
          kBox,

          //donate organs
          Padding(
            padding: EdgeInsets.all(10.0),
            child: CustomRadioButtonGroup(
              onChanged: (String? value) {
                setState(() {
                  widget.formData.donateOrgan = value == "Yes" ? true : false;
                });
              },
              options: ['Yes', 'No'],
              title: 'Donate Organs in case of the accidental death?',
            ),
          ),

          //acknowledgement
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  value: widget.formData.acknowledgement,
                  onChanged: (bool? val) {
                    setState(() {
                      widget.formData.acknowledgement = val!;
                    });
                  },
                  activeColor: kSecondaryColor,
                ),
                Text(
                    'I here by declare that to the best of my knowledge \nand belief the particulars given aboveare true.'),
              ],
            ),
          ),
          kBox,
        ],
      ),
    );
  }
}

//box for different section
class MyContainer extends StatelessWidget {
  final Widget child;
  MyContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      padding: EdgeInsets.all(10),
      child: child,
    );
  }
}

//personal details
class FillPersonalDetails extends StatefulWidget {
  final FormData formData;
  FillPersonalDetails({
    Key? key,
    required this.formData,
  }) : super(key: key);

  @override
  _FillPersonalDetailsState createState() => _FillPersonalDetailsState();
}

class _FillPersonalDetailsState extends State<FillPersonalDetails> {
  final List<String> relationOptions = [
    'Father',
    'Mother',
    'Husband',
    'Guardian'
  ];
  final List<String> countryOptions = [
    'India',
    'Other',
  ];

  final List<String> qualificationOptions = [
    '10th',
    '12th',
    'Graduate',
    'Masters',
    'Doctorate',
  ];

  final List<String> bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-',
  ];

//datepicker dialog show up and update the dateof birth
  Future<void> _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.formData.selectedDateOfBirth != null
          ? widget.formData.selectedDateOfBirth!
          : DateTime.now(),
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: kSecondaryColor, // Header background color
            colorScheme: ColorScheme.light(
              primary: kSecondaryColor, // Selected date background color
              onPrimary: Colors.white, // Text color of selected date
              onSurface: Colors.black, // Text color on calendar
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        widget.formData.selectedDateOfBirth = pickedDate;
      });
      FocusScope.of(context).requestFocus(widget.formData.placeOfBirthFocus);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Personal Details",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        kBox,

        UserInput(
          controller: widget.formData.fullNameController,
          hint: "Enter Full Name",
          keyboardType: TextInputType.name,
          width: double.infinity,
          textAlignment: TextAlign.start,
          focusNode: widget.formData.fullNameFocus,
        ),
        kBox,

        // Dropdown for relation
        DropdownButtonFormField<String>(
          decoration: kDropdown("Relation"),
          value: widget.formData.selectedRelation,
          items: relationOptions.map((relation) {
            return DropdownMenuItem<String>(
              value: relation,
              child: Text(relation),
            );
          }).toList(),
          onChanged: (String? val) {
            FocusScope.of(context)
                .requestFocus(widget.formData.relativeFullNameFocus);
          },
        ),
        kBox,

        //Relative full name
        UserInput(
          controller: widget.formData.relativeFullNameController,
          hint: "Enter Relative Full Name",
          keyboardType: TextInputType.name,
          width: double.infinity,
          textAlignment: TextAlign.start,
          focusNode: widget.formData.relativeFullNameFocus,
        ),
        kBox,

        //gender select
        CustomRadioButtonGroup(
          options: ['Male', 'Female', 'Other'],
          title: 'Gender',
          onChanged: (String? value) {
            setState(() {
              widget.formData.selectedGender = value;
            });
          },
        ),
        kBox,

        //SELECT DOB
        Row(
          children: [
            Text("Select Your Birthday:   ", style: TextStyle(fontSize: 16)),
            GestureDetector(
              onTap: () => _pickDate(context),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: kSecondaryColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  // ignore: unnecessary_null_comparison
                  widget.formData.selectedDateOfBirth != null
                      ? DateFormat('dd/MM/yyyy')
                          .format(widget.formData.selectedDateOfBirth!)
                      : "DD/MM/YYYY",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
        kBox,

        //place of birth
        UserInput(
          controller: widget.formData.placeOfBirthController,
          keyboardType: TextInputType.text,
          hint: 'Enter Place of Birth',
          textAlignment: TextAlign.start,
          focusNode: widget.formData.placeOfBirthFocus,
          width: double.infinity,
        ),
        kBox,

        //country of birth
        DropdownButtonFormField<String>(
          decoration: kDropdown("Country of Birth"),
          value: widget.formData.selectedCountryOfBirth,
          items: countryOptions.map((country) {
            return DropdownMenuItem<String>(
              value: country,
              child: Text(country),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              widget.formData.selectedCountryOfBirth = newValue;
            });
          },
        ),
        kBox,

        //qualification
        DropdownButtonFormField<String>(
          decoration: kDropdown("Qualification"),
          value: widget.formData.selectedQualification,
          items: qualificationOptions.map((qualification) {
            return DropdownMenuItem<String>(
              value: qualification,
              child: Text(qualification),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              widget.formData.selectedQualification = newValue;
            });
          },
        ),
        kBox,

        //Blood group
        DropdownButtonFormField<String>(
          decoration: kDropdown("Blood Group"),
          value: widget.formData.selectedBloodGroup,
          items: bloodGroups.map((blood) {
            return DropdownMenuItem<String>(
              value: blood,
              child: Text(blood),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              widget.formData.selectedBloodGroup = newValue;
            });
            FocusScope.of(context).requestFocus(widget.formData.emailFocus);
          },
        ),
        kBox,

        //email address
        UserInput(
          controller: widget.formData.emailController,
          hint: "Enter email Address",
          keyboardType: TextInputType.emailAddress,
          width: double.infinity,
          textAlignment: TextAlign.start,
          focusNode: widget.formData.emailFocus,
          submit: (_) {
            FocusScope.of(context).requestFocus(widget.formData.landlineFocus);
          },
        ),
        kBox,

        //Landline number
        UserInput(
          controller: widget.formData.landlineController,
          hint: "Enter Landline Number",
          keyboardType: TextInputType.number,
          width: double.infinity,
          textAlignment: TextAlign.start,
          focusNode: widget.formData.landlineFocus,
          maxLength: 11,
          submit: (_) {
            FocusScope.of(context)
                .requestFocus(widget.formData.applicantMobileFocus);
          },
        ),
        kBox,

        //applicant mobile
        UserInput(
          controller: widget.formData.applicantMobileController,
          hint: "Enter Mobile Number",
          keyboardType: TextInputType.number,
          width: double.infinity,
          textAlignment: TextAlign.start,
          focusNode: widget.formData.applicantMobileFocus,
          maxLength: 10,
          submit: (_) {
            FocusScope.of(context)
                .requestFocus(widget.formData.emergencyMobileFocus);
          },
        ),
        kBox,

        //Emergency mobile no
        UserInput(
          controller: widget.formData.emergencyMobileController,
          hint: "Enter Emergency Number",
          keyboardType: TextInputType.number,
          width: double.infinity,
          textAlignment: TextAlign.start,
          focusNode: widget.formData.emergencyMobileFocus,
          maxLength: 10,
          submit: (_) {
            FocusScope.of(context)
                .requestFocus(widget.formData.identityMark1Focus);
          },
        ),
        kBox,

        //identity mark 1
        UserInput(
          controller: widget.formData.identityMark1Controller,
          hint: "Identity Mark 1",
          keyboardType: TextInputType.text,
          width: double.infinity,
          textAlignment: TextAlign.start,
          focusNode: widget.formData.identityMark1Focus,
          submit: (_) {
            FocusScope.of(context)
                .requestFocus(widget.formData.identityMark2Focus);
          },
        ),
        kBox,

        //identity mark 2
        UserInput(
          controller: widget.formData.identityMark2Controller,
          hint: "Identity Mark 2",
          keyboardType: TextInputType.text,
          width: double.infinity,
          textAlignment: TextAlign.start,
          focusNode: widget.formData.identityMark2Focus,
          submit: (_) {
            FocusScope.of(context)
                .requestFocus(widget.formData.identityMark2Focus);
          },
        ),
      ],
    );
  }
}

//address details
// ignore: must_be_immutable
class FillAddressDetails extends StatefulWidget {
  final FormData formData;
  FillAddressDetails({
    Key? key,
    required this.formData,
  }) : super(key: key);

  @override
  _FillAddressDetailsState createState() => _FillAddressDetailsState();
}

class _FillAddressDetailsState extends State<FillAddressDetails> {
  List<String> stateList = [];
  List<String> presentDistrictList = [];
  List<String> permanentDistrictList = [];
  @override
  void initState() {
    super.initState();
    fetchStates();
  }

  // Fetch all states (document IDs from the 'states' collection)
  Future<void> fetchStates() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('states').get();
    List<String> states = snapshot.docs.map((doc) => doc.id).toList()..sort();
    setState(() {
      stateList = states;
    });
  }

  // Fetch districts for the selected state from its document
  Future<void> fetchDistricts(String state) async {
    DocumentSnapshot docSnapshot =
        await FirebaseFirestore.instance.collection('states').doc(state).get();
    if (docSnapshot.exists) {
      List<dynamic> districts = docSnapshot.get('districts');
      setState(() {
        if (presentDistrictList.isEmpty) {
          presentDistrictList = districts.map((d) => d.toString()).toList();
        }
        permanentDistrictList = districts.map((d) => d.toString()).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Address Details",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "Present Address",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        kBox,

        //present states
        DropdownButtonFormField<String>(
          decoration: kDropdown("State"),
          value: widget.formData.presentState,
          items: stateList.map((state) {
            return DropdownMenuItem<String>(
              value: state,
              child: Text(state),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              widget.formData.presentState = newValue;
              widget.formData.presentDistrict =
                  null; // reset district selection
              presentDistrictList = [];
            });
            if (newValue != null) {
              fetchDistricts(newValue);
            }
          },
        ),
        kBox,

        // present districts
        DropdownButtonFormField<String>(
          decoration: kDropdown("District"),
          value: widget.formData.presentDistrict,
          items: presentDistrictList.map((district) {
            return DropdownMenuItem<String>(
              value: district,
              child: Text(district),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              widget.formData.presentDistrict = newValue;
            });
            FocusScope.of(context)
                .requestFocus(widget.formData.presentTehsilFocus);
          },
        ),
        kBox,

        //present tehsil
        UserInput(
          controller: widget.formData.presentTehsilController,
          hint: "Enter Tehsil",
          keyboardType: TextInputType.text,
          width: double.infinity,
          textAlignment: TextAlign.start,
          focusNode: widget.formData.presentTehsilFocus,
          submit: (_) {
            FocusScope.of(context)
                .requestFocus(widget.formData.presentVillageFocus);
          },
        ),
        kBox,

        //present town
        UserInput(
          controller: widget.formData.presentVillageController,
          hint: "Enter Village/Town/City",
          keyboardType: TextInputType.text,
          width: double.infinity,
          textAlignment: TextAlign.start,
          focusNode: widget.formData.presentVillageFocus,
          submit: (_) {
            FocusScope.of(context)
                .requestFocus(widget.formData.presentAddressFocus);
          },
        ),
        kBox,

        //present address
        UserInput(
          controller: widget.formData.presentAddressController,
          hint: "Enter Full Address",
          keyboardType: TextInputType.text,
          width: double.infinity,
          textAlignment: TextAlign.start,
          focusNode: widget.formData.presentAddressFocus,
          submit: (_) {
            FocusScope.of(context)
                .requestFocus(widget.formData.presentLandmarkFocus);
          },
        ),
        kBox,

        //present landmark
        UserInput(
          controller: widget.formData.presentLandmarkController,
          hint: "Enter Landmark",
          keyboardType: TextInputType.text,
          width: double.infinity,
          textAlignment: TextAlign.start,
          focusNode: widget.formData.presentLandmarkFocus,
          submit: (_) {
            FocusScope.of(context)
                .requestFocus(widget.formData.presentPincodeFocus);
          },
        ),
        kBox,

        //present pincode
        UserInput(
          controller: widget.formData.presentPincodeController,
          hint: "Enter Pincode",
          keyboardType: TextInputType.number,
          width: double.infinity,
          textAlignment: TextAlign.start,
          maxLength: 6,
          focusNode: widget.formData.presentPincodeFocus,
        ),
        kBox,

        Text(
          "Permanent Address",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        kBox,

        //checkbox
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              value: widget.formData.sameAsPresent,
              onChanged: (bool? val) {
                setState(() {
                  widget.formData.sameAsPresent = val!;
                  if (val) {
                    widget.formData.permanentState =
                        widget.formData.presentState;
                    widget.formData.permanentDistrict =
                        widget.formData.presentDistrict;
                    widget.formData.permanentTehsilController.text =
                        widget.formData.presentTehsilController.text;
                    widget.formData.permanentVillageController.text =
                        widget.formData.presentVillageController.text;
                    widget.formData.permanentAddressController.text =
                        widget.formData.presentAddressController.text;
                    widget.formData.permanentLandmarkController.text =
                        widget.formData.presentLandmarkController.text;
                    widget.formData.permanentPincodeController.text =
                        widget.formData.presentPincodeController.text;
                  } else {
                    widget.formData.permanentState = null;
                    widget.formData.permanentDistrict = null;
                    permanentDistrictList = [];
                    widget.formData.permanentTehsilController.clear();
                    widget.formData.permanentVillageController.clear();
                    widget.formData.permanentAddressController.clear();
                    widget.formData.permanentLandmarkController.clear();
                    widget.formData.permanentPincodeController.clear();
                  }
                });
              },
              activeColor: kSecondaryColor,
            ),
            Text('Same As Present Address'),
          ],
        ),
        kBox,

        //permanent states
        DropdownButtonFormField<String>(
          decoration: kDropdown("State"),
          value: widget.formData.permanentState,
          items: stateList.map((state) {
            return DropdownMenuItem<String>(
              value: state,
              child: Text(state),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              widget.formData.permanentState = newValue;
              widget.formData.permanentDistrict =
                  null; // reset district selection
              permanentDistrictList = [];
            });
            if (newValue != null) {
              fetchDistricts(newValue);
            }
          },
        ),
        kBox,

        // permanent districts
        DropdownButtonFormField<String>(
          decoration: kDropdown("District"),
          value: widget.formData.permanentDistrict,
          items: permanentDistrictList.map((district) {
            return DropdownMenuItem<String>(
              value: district,
              child: Text(district),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              widget.formData.permanentDistrict = newValue;
            });
            FocusScope.of(context)
                .requestFocus(widget.formData.permanentTehsilFocus);
          },
        ),
        kBox,

        //permanent tehsil
        UserInput(
          controller: widget.formData.permanentTehsilController,
          hint: "Enter Tehsil",
          keyboardType: TextInputType.text,
          width: double.infinity,
          textAlignment: TextAlign.start,
          focusNode: widget.formData.permanentTehsilFocus,
          submit: (_) {
            FocusScope.of(context)
                .requestFocus(widget.formData.permanentVillageFocus);
          },
        ),
        kBox,

        //permanent town
        UserInput(
          controller: widget.formData.permanentVillageController,
          hint: "Enter Village/Town/City",
          keyboardType: TextInputType.text,
          width: double.infinity,
          textAlignment: TextAlign.start,
          focusNode: widget.formData.permanentVillageFocus,
          submit: (_) {
            FocusScope.of(context)
                .requestFocus(widget.formData.permanentAddressFocus);
          },
        ),
        kBox,

        //permanent address
        UserInput(
          controller: widget.formData.permanentAddressController,
          hint: "Enter Full Address",
          keyboardType: TextInputType.text,
          width: double.infinity,
          textAlignment: TextAlign.start,
          focusNode: widget.formData.permanentAddressFocus,
          submit: (_) {
            FocusScope.of(context)
                .requestFocus(widget.formData.permanentLandmarkFocus);
          },
        ),
        kBox,

        //permanent landmark
        UserInput(
          controller: widget.formData.permanentLandmarkController,
          hint: "Enter Landmark",
          keyboardType: TextInputType.text,
          width: double.infinity,
          textAlignment: TextAlign.start,
          focusNode: widget.formData.permanentLandmarkFocus,
          submit: (_) {
            FocusScope.of(context)
                .requestFocus(widget.formData.permanentPincodeFocus);
          },
        ),
        kBox,

        //permanent pincode
        UserInput(
          controller: widget.formData.permanentPincodeController,
          hint: "Enter Pincode",
          keyboardType: TextInputType.number,
          width: double.infinity,
          textAlignment: TextAlign.start,
          maxLength: 6,
          focusNode: widget.formData.permanentPincodeFocus,
        ),
        kBox,
      ],
    );
  }
}

//Class of vehicle
class FillVehicleClass extends StatefulWidget {
  final FormData formData;
  FillVehicleClass({Key? key, required this.formData}) : super(key: key);

  @override
  _FillVehicleClassState createState() => _FillVehicleClassState();
}

class _FillVehicleClassState extends State<FillVehicleClass> {
  final List<String> vehicleClasses = [
    'Select All applicable classes',
    'Motor Cycle Less Than 50CC (MC50CC)',
    'Motor Cycle with Gear (Non Transport) (MCWG)',
    'Light Motor Vehicle (LMV)',
    'LMV - 3 Wheeler NT (3W-NT)',
    'LMV - 3 Wheeler CAB (3W-CAB)',
    'LMV - 3 Wheeler Transport Goods Non PSV (3W-GV)',
    'Road Roller (RDRLR)',
    'Other Others (OTHER)',
    'Others - Cranes (CRANE)',
    'Others - Forklift (FLIFT)',
    'Others - Boring Rigg (BRIGS)',
    'Others - Construction Equipments (CNEQP)',
    'Others - Harvester (HARVST)',
    'Others - Trailers (TRAILR)',
    'Others - Agriculture Tractor and Power Tiller (AGRTLR)',
    'Others - Tow Trucks (TOWTRK)',
    'Others - Breakdown Van and Recovery Van (BRKREC)',
    'Motor Cycle without Gear (Non Transport) (MCWOG)',
    'Adapted Vehicle (ADPVEH)',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Class of Vehicle",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        kBox,

        // Dropdown for vehicle class
        DropdownButtonFormField<String>(
          decoration: kDropdown("Select Vehicle Class"),
          value: "Select All applicable classes",
          items: vehicleClasses.map((vehicleClass) {
            return DropdownMenuItem<String>(
              value: vehicleClass,
              child: Tooltip(
                // Tooltip to show full text on hover
                message: vehicleClass,
                child: SizedBox(
                  width:
                      MediaQuery.of(context).size.width * 0.7, // Adjust width
                  child: Text(
                    vehicleClass,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (!widget.formData.selectedVehicleClasses.contains(newValue) &&
                newValue != "Select All applicable classes") {
              setState(() {
                widget.formData.selectedVehicleClasses.add(newValue!);
              });
            }
          },
        ),
        kBox,

        widget.formData.selectedVehicleClasses.isNotEmpty ?
        SizedBox(
              height: 150.0,
              child: ListView(
                children:
                    widget.formData.selectedVehicleClasses.map((vehicleClass) {
                  return ListTile(
                    title: Text(vehicleClass),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          widget.formData.selectedVehicleClasses
                              .remove(vehicleClass);
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ): SizedBox(

            ),
      ],
    );
  }
}

//Declaration form
class FillDeclarationForm extends StatefulWidget {
  final FormData formData;
  FillDeclarationForm({
    Key? key,
    required this.formData,
  }) : super(key: key);

  @override
  _FillDeclarationFormState createState() => _FillDeclarationFormState();
}

class _FillDeclarationFormState extends State<FillDeclarationForm> {
  final List<String> options = ['Yes', 'No'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Application cum Declaration to Physical Fitness",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "Declaration:",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),

        //Questions
        CustomRadioButtonGroup(
          options: options,
          title:
              '1. Do you suffer from epilepsy or from sudden attacks of loss of consciousness or giddiness from any cause?',
          onChanged: (String? value) {
            setState(() {
              widget.formData.declarationAnswer1 =
                  value == "Yes" ? true : false;
            });
          },
        ),
        kBox,

        CustomRadioButtonGroup(
          options: options,
          title: '2. Are you able to distinguish with each eye?',
          onChanged: (String? value) {
            setState(() {
              widget.formData.declarationAnswer2 =
                  value == "Yes" ? true : false;
            });
          },
        ),
        kBox,

        CustomRadioButtonGroup(
          options: options,
          title:
              '3. Have you lost either hand or foot or are you suffering from any defects of muscular, control or muscular power of either arm or leg?',
          onChanged: (String? value) {
            setState(() {
              widget.formData.declarationAnswer3 =
                  value == "Yes" ? true : false;
            });
          },
        ),
        kBox,

        CustomRadioButtonGroup(
          options: options,
          title: '4. Do you suffer from night blindness?',
          onChanged: (String? value) {
            setState(() {
              widget.formData.declarationAnswer4 =
                  value == "Yes" ? true : false;
            });
          },
        ),
        kBox,

        CustomRadioButtonGroup(
          options: options,
          title:
              '5. Are you so deaf as to be unable to hear (and if the application is for driving a light motor vehicle, with or without hearing aid) the ordinary sound signal?',
          onChanged: (String? value) {
            setState(() {
              widget.formData.declarationAnswer5 =
                  value == "Yes" ? true : false;
            });
          },
        ),
        kBox,

        CustomRadioButtonGroup(
          options: options,
          title:
              '6. Do you suffer from any other disease or disability likely to cause your driving of a motor vehicle to be a source of danger to the public, if so, give details?',
          onChanged: (String? value) {
            setState(() {
              widget.formData.declarationAnswer6 =
                  value == "Yes" ? true : false;
            });
          },
        ),
        kBox,

        //declaration acknowledgement
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              value: widget.formData.declarationChecked,
              onChanged: (bool? val) {
                setState(() {
                  widget.formData.declarationChecked = val!;
                });
              },
              activeColor: kSecondaryColor,
            ),
            Text(
                'I here by declare all the info provided in\nabove declartion are true and I am liable \nto any possible punishment if found false.'),
          ],
        ),
        kBox,
      ],
    );
  }
}
