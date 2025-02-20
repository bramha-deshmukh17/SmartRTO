import 'package:flutter/material.dart';

import 'Constants.dart';

class CustomRadioButtonGroup extends StatefulWidget {
  final List<String> options; // List of radio button options
  final String title;
  final Function(String) onChanged; // Callback when value changes

  const CustomRadioButtonGroup({
    super.key,
    required this.options,
    required this.title,
    required this.onChanged,
  });

  @override
  _CustomRadioButtonGroupState createState() => _CustomRadioButtonGroupState();
}

class _CustomRadioButtonGroupState extends State<CustomRadioButtonGroup> {
  String? _selectedValue; // Stores selected option

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(widget.title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        SizedBox(width: 10), // Add spacing between title and options
        Wrap(
          spacing: 10.0, // Space between radio buttons
          children: widget.options
              .map((option) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<String>(
                        value: option,
                        groupValue: _selectedValue,
                        onChanged: (value) {
                          setState(() {
                            _selectedValue = value;
                          });
                          widget.onChanged(value!);
                        },
                        activeColor: kSecondaryColor,
                      ),
                      Text(option),
                    ],
                  ))
              .toList(),
        ),
      ],
    );

  }
}
