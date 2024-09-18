import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_rto/Utility/Constants.dart';
import 'package:smart_rto/Utility/RoundButton.dart';
import 'package:smart_rto/Utility/UserInput.dart';

class GenerateFines extends StatefulWidget {
  static const String id = 'generateFines';
  const GenerateFines({super.key});

  @override
  State<GenerateFines> createState() => _GenerateFinesState();
}

class _GenerateFinesState extends State<GenerateFines> {
  final TextEditingController _numberController = TextEditingController();
  // Initial selected value
  String? selectedValue;

  // List of items for the dropdown
  List<String> items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
  ];

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
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      FontAwesomeIcons.camera,
                      color: kBlack,
                    ),
                  ),
                ],
              ),
              UserInput(
                  controller: _numberController,
                  hint: 'Enter Vehicle No.',
                  keyboardType: TextInputType.text),
              const SizedBox(
                height: 20.0,
              ),
              Container(
                width: 250.0,
                height: 60.0,
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: kSecondaryColor,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButton<String>(
                  underline: SizedBox(),
                  value: selectedValue, // Current value of the dropdown
                  hint: const Text(
                      'Select an item'), // Hint text when nothing is selected
                  items: items.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue; // Update the selected value
                    });
                  },
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              RoundButton(onPressed: (){}, text: 'Generate'),
            ],
          ),
        ),
      ),
    );
  }
}
