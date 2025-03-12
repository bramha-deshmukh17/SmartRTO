import 'package:flutter/material.dart';
import 'Constants.dart';

class CustomRadioButtonGroup extends StatefulWidget {
  final List<String> options; // List of radio button options
  final String title;
  final Function(String) onChanged;
  final String? errorText;
  final String? value; // Optional default value

  const CustomRadioButtonGroup({
    super.key,
    required this.options,
    required this.title,
    required this.onChanged,
    this.errorText,
    this.value,
  });

  @override
  _CustomRadioButtonGroupState createState() => _CustomRadioButtonGroupState();
}

class _CustomRadioButtonGroupState extends State<CustomRadioButtonGroup> {
  String? _selectedValue; // Stores selected option

  @override
  void initState() {
    super.initState();
    // Initialize _selectedValue only if widget.value is valid
    if (widget.value != null && widget.options.contains(widget.value)) {
      _selectedValue = widget.value;
    }
  }

  @override
  void didUpdateWidget(CustomRadioButtonGroup oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the value changes in the parent, update _selectedValue.
    if (widget.value != oldWidget.value &&
        widget.options.contains(widget.value)) {
      setState(() {
        _selectedValue = widget.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final radioButtons = widget.options.map((option) {
      return Row(
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
      );
    }).toList();

    // Layout based on title length (example logic)
    return widget.title.length >= 10
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 5),
              Wrap(
                spacing: 10.0,
                runSpacing: 5.0,
                children: radioButtons,
              ),
              if (widget.errorText != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    widget.errorText!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(widget.title,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10),
                  Wrap(
                    spacing: 10.0,
                    children: radioButtons,
                  ),
                ],
              ),
              if (widget.errorText != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    widget.errorText!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
            ],
          );
  }
}
