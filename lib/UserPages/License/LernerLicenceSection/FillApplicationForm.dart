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
      print("Updated Date of Birth: ${widget.formData.selectedDateOfBirth}");
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
          MyContainer(
            child: FillPersonalDetails(formData: widget.formData),
          ),
          kBox,
        ],
      ),
    );
  }
}

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
            FocusScope.of(context).requestFocus(widget.formData.relativeFullNameFocus);
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
          onChanged: (String? value) {},
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
            FocusScope.of(context).requestFocus(widget.formData.identityMark1Focus);
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
            FocusScope.of(context).requestFocus(widget.formData.identityMark2Focus);
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
