import 'package:flutter/material.dart';

import 'Constants.dart';

class UserInput  extends StatelessWidget {
  final String hint;
  final dynamic maxLength;
  final dynamic keyboardType;
  final dynamic controller;
  final dynamic obscureText;
  final dynamic errorText;
  final dynamic submit;
  final dynamic focusNode;
  final dynamic maxlines;
  final dynamic readonly;


  const UserInput({super.key, required this.controller, required this.hint, this.focusNode, this.submit, required this.keyboardType, this.maxLength, this.obscureText = false, this.errorText, this.maxlines, this.readonly=false});

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: 250.0,
      child: TextField(
        enabled: true,
        readOnly: readonly,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLength: maxLength,
        maxLines: maxlines,
        style: const TextStyle(fontFamily: 'InriaSans',),

        onSubmitted: submit,

        decoration: InputDecoration(
          labelText: hint,
          errorText: errorText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0), // Rounded corners
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: kSecondaryColor, // Border color when not focused
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: kSecondaryColor, // Border color when focused
              //width: 2.0, // Border width
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}
