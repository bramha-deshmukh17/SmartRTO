import 'package:flutter/material.dart';
import '/Utility/Constants.dart';

class RoundButton extends StatelessWidget {
  final dynamic onPressed;

  final dynamic text;

  const RoundButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      fillColor: kSecondaryColor, // Background color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0), // Rounded corners
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 12.0,
      ), // Padding
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18.0, // Text size
          color: Colors.white, // Text color
        ),
      ),
    );
  }
}
